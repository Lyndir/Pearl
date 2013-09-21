/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  AbstractWSController.m
//  Pearl
//
//  Created by Maarten Billemont on 04/06/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import "PearlWSController.h"
#import "NSDictionary_JSONExtensions.h"
#import "NSString+PearlNSArrayFormat.h"
#ifdef PEARL_UIKIT
#import "PearlAlert.h"
#endif
#import "ASIFormDataRequest.h"
#import "ASIHttpRequest.h"
#import "PearlLogger.h"
#import "PearlStringUtils.h"
#import "CJSONSerializer.h"
#import "NSObject+PearlExport.h"

#define JSON_NON_EXECUTABLE_PREFIX      @")]}'\n"

#define REQUEST_KEY_VERSION             @"version"


@implementation PearlJSONResult

@synthesize code = _code, outdated = _outdated;
@synthesize userDescription = _userDescription, userDescriptionArguments = _userDescriptionArguments;
@synthesize technicalDescription = _technicalDescription;
@synthesize result = _result;

- (id)initWithDictionary:(NSDictionary *)aDictionary {

    if (!(aDictionary == nil || (self = [super init])))
        return nil;

    self.code                     = [NSNullToNil([aDictionary valueForKeyPath:@"code"]) intValue];
    self.outdated                 = [NSNullToNil([aDictionary valueForKeyPath:@"outdated"]) boolValue];
    self.userDescription          = NSNullToNil([aDictionary valueForKeyPath:@"userDescription"]);
    self.userDescriptionArguments = NSNullToNil([aDictionary valueForKeyPath:@"userDescriptionArguments"]);
    self.technicalDescription     = NSNullToNil([aDictionary valueForKeyPath:@"technicalDescription"]);
    self.result                   = NSNullToNil([aDictionary valueForKeyPath:@"result"]);

    return self;
}

@end

@implementation PearlWSController
@synthesize suppressOutdatedWarning = _suppressOutdatedWarning;

#pragma mark ###############################
#pragma mark Lifecycle

+ (instancetype)get {

    static PearlWSController *instance;
    if (!instance)
        instance = [self new];

    return instance;
}


#pragma mark ###############################
#pragma mark Behaviors


- (NSURL *)serverURL {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You must override this method." userInfo:nil];
}

- (void)upgrade {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You must override this method." userInfo:nil];
}

- (BOOL)isSynchronous {

    return NO;
}

- (void)reset {

    [ASIHTTPRequest clearSession];
    self.suppressOutdatedWarning = NO;
}

- (ASIHTTPRequest *)requestWithDictionary:(NSDictionary *)parameters method:(PearlWSRequestMethod)method
                               completion:(void (^)(NSData *responseData, NSError *connectionError))completion {

    trc(@"Out to %@, method: %d:\n%@", [self serverURL], method, parameters);
    ASIHTTPRequest *request = nil;
    NSData *(^loadRequest)(void) = nil;

    switch (method) {
        case PearlWSRequestMethodGET_REST: {
            ASIFormDataRequest *formRequest = [[ASIFormDataRequest alloc] initWithURL:[self serverURL]];
            request = formRequest;

            NSMutableString *urlString = [[[self serverURL] absoluteString] mutableCopy];
            BOOL hasQuery = [urlString rangeOfString:@"?"].location != NSNotFound;

            for (NSString *key in [parameters allKeys]) {
                id value = [parameters objectForKey:key];
                if (value != [NSNull null]) {
                    [urlString appendFormat:@"%s%@=%@", hasQuery? "&": "?",
                                            [formRequest encodeURL:key],
                                            [formRequest encodeURL:[value description]]];
                    hasQuery = YES;
                }
            }
            [urlString appendFormat:@"%s%@=%@", hasQuery? "&": "?",
                                    [formRequest encodeURL:REQUEST_KEY_VERSION],
                                    [formRequest encodeURL:[PearlConfig get].build]];

            loadRequest = [^{
                NSError       *error        = nil;
                NSURLResponse *response     = nil;
                NSData        *responseData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                                                               returningResponse:&response error:&error];
                request.error = error;

                return responseData;
            } copy];
            break;
        }

        case PearlWSRequestMethodPOST_REST: {
            // Build the request.
            ASIFormDataRequest *formRequest = [[ASIFormDataRequest alloc] initWithURL:[self serverURL]];
            request = formRequest;

            [formRequest setPostFormat:ASIURLEncodedPostFormat];
            [formRequest setDelegate:self];
            for (NSString *key in [parameters allKeys]) {
                id value = [parameters objectForKey:key];
                if (value != [NSNull null])
                    [formRequest setPostValue:[value description] forKey:key];
            }
            [formRequest setPostValue:[PearlConfig get].build forKey:REQUEST_KEY_VERSION];

            loadRequest = [^{
                [request startSynchronous];

                return request.responseData;
            } copy];
            break;
        }

        case PearlWSRequestMethodPOST_JSON: {
            // Build the request.
            request = [[ASIHTTPRequest alloc] initWithURL:[self serverURL]];

            NSError *jsonError = nil;
            [request setPostBody:[[[CJSONSerializer serializer] serializeDictionary:parameters error:&jsonError] mutableCopy]];
            if (jsonError != nil) {
                err(@"JSON: %@, for request:\n%@", jsonError, request.url);
                return nil;
            }

            loadRequest = [^{
                [request startSynchronous];

                return request.responseData;
            } copy];
            break;
        }
    }

    dispatch_block_t handleRequest = [^{
        NSData *responseData = loadRequest();
        if ([request isCancelled]) {
            dbg(@"Cancelled: %@", request.url);
            completion(nil, nil);
        }

        if (request.error)
        err(@"Failed from: %@, error: %@", request.url, request.error);
        else
         trc(@"In from: %@, data:\n%@", request.url, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);

        if ([self isSynchronous])
            completion(responseData, request.error);
        else
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(responseData, request.error);
            });
    } copy];

    if (request) {
        if ([self isSynchronous])
            handleRequest();
        else
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), handleRequest);
    } else
     err(@"Request method not supported: %d", method);

    return request;
}

- (id)requestWithObject:(id)object method:(PearlWSRequestMethod)method popupOnError:(BOOL)popupOnError
             completion:(void (^)(BOOL success, PearlJSONResult *response, NSError *connectionError))completion {

    return [self requestWithDictionary:[object exportToDictionary] method:method completion:^(NSData *responseData, NSError *connectionError) {
        PearlJSONResult *response = nil;
        BOOL valid = !connectionError && [self validateAndParseResponse:responseData into:&response
                                                           popupOnError:popupOnError requires:nil];

        completion(valid, response, connectionError);
    }];
}


- (BOOL)validateAndParseResponse:(NSData *)responseData into:(__autoreleasing PearlJSONResult **)response popupOnError:(BOOL)popupOnError
                        requires:(NSString *)key, ... {

    *response = nil;
    if (responseData == nil || !responseData.length) {
#ifdef PEARL_UIKIT
        if (popupOnError)
            [PearlAlert showError:[PearlWSStrings get].errorWSConnection];
#endif
        return NO;
    }

    // Trim off non-executable-JSON prefix.
    if (responseData.length >= [JSON_NON_EXECUTABLE_PREFIX length] &&
     [JSON_NON_EXECUTABLE_PREFIX isEqualToString:
                                  [[NSString alloc] initWithData:[responseData subdataWithRange:NSMakeRange(0,
                                                                                                            [JSON_NON_EXECUTABLE_PREFIX length])]
                                             encoding:NSUTF8StringEncoding]])
        responseData = [responseData subdataWithRange:
                                      NSMakeRange([JSON_NON_EXECUTABLE_PREFIX length],
                                                  [responseData length] - [JSON_NON_EXECUTABLE_PREFIX length])];

    // Parse the JSON response data.
    id jsonError = nil;
    NSDictionary *resultDictionary = [NSDictionary dictionaryWithJSONData:responseData error:&jsonError];
    if (jsonError != nil) {
        err(@"JSON: %@, for response:\n%@", jsonError, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
#ifdef PEARL_UIKIT
        if (popupOnError)
            [PearlAlert showError:[PearlWSStrings get].errorWSResponseInvalid];
#endif
        return NO;
    }
    *response = [[PearlJSONResult alloc] initWithDictionary:resultDictionary];
    if (!*response) {
#ifdef PEARL_UIKIT
        if (popupOnError)
            [PearlAlert showError:[PearlWSStrings get].errorWSResponseInvalid];
#endif
        return NO;
    }

    // Check whether the client is up-to-date enough.
#ifdef PEARL_UIKIT
    if (popupOnError)
        if ((*response).outdated) {
            if ((*response).code == PearlJSONResultCodeUpdateRequired)
             // Required upgrade.
                [PearlAlert showAlertWithTitle:[PearlStrings get].commonTitleError
                            message:[PearlWSStrings get].errorWSResponseOutdatedRequired
                            viewStyle:UIAlertViewStyleDefault
                            initAlert:nil tappedButtonBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
                    if (buttonIndex == [alert firstOtherButtonIndex])
                        [self upgrade];
                } cancelTitle:[PearlStrings get].commonButtonBack otherTitles:[PearlStrings get].commonButtonUpgrade, nil];
            else
                if (!self.suppressOutdatedWarning) {
                    // Optional upgrade.
                    [PearlAlert showAlertWithTitle:[PearlStrings get].commonTitleError
                                message:[PearlWSStrings get].errorWSResponseOutdatedOptional
                                viewStyle:UIAlertViewStyleDefault
                                initAlert:nil tappedButtonBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
                        if (buttonIndex == [alert firstOtherButtonIndex])
                            [self upgrade];
                    } cancelTitle:[PearlStrings get].commonButtonBack otherTitles:[PearlStrings get].commonButtonUpgrade, nil];
                    self.suppressOutdatedWarning = YES;
                }
        }
#endif

    if ((*response).code != PearlJSONResultCodeSuccess) {
        err(@"Result Code %d: %@", (*response).code, (*response).technicalDescription);

#ifdef PEARL_UIKIT
        if (popupOnError && (*response).code != PearlJSONResultCodeUpdateRequired) {
            NSString *errorMessage = (*response).userDescription;
            if (errorMessage && errorMessage.length) {
                [PearlAlert showError:[NSString stringWithFormat:PearlLocalize(errorMessage) array:(*response).userDescriptionArguments]];
            }
            else
                [PearlAlert showError:[PearlWSStrings get].errorWSResponseFailed];
        }
#endif

        return NO;
    }

    // Validate whether all required keys are set.  Keys are resolved using KVC.
    va_list args;
    va_start(args, key);
    for (NSString *nextKey = key; nextKey; nextKey = va_arg(args, NSString*)) {
        id value = nil;
        @try {
            value = NSNullToNil([(*response) valueForKeyPath:nextKey]);
        }
        @catch (NSException *e) {
        }

        if (!value) {
            err(@"Missing key: %@, in result: %@", nextKey, *response);

#ifdef PEARL_UIKIT
            if (popupOnError)
                [PearlAlert showError:[PearlWSStrings get].errorWSResponseInvalid];
#endif
            return NO;
        }
    }
    va_end(args);

    return YES;
}

@end
