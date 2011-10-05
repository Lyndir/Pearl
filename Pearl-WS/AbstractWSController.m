//
//  AbstractWSController.m
//  Pearl
//
//  Created by Maarten Billemont on 04/06/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import "AbstractWSController.h"
#import "NSDictionary_JSONExtensions.h"
#import "NSString_NSArrayFormat.h"
#ifdef PEARL_UIKIT
#import "AlertViewController.h"
#endif
#import "ASIFormDataRequest.h"
#import "ASIHttpRequest.h"
#import "Logger.h"
#import "StringUtils.h"
#import "CJSONSerializer.h"
#import "NSObject_Export.h"

#define JSON_NON_EXECUTABLE_PREFIX      @")]}'\n"

#define CODE_SUCCESS                    0
#define CODE_FAILURE_GENERIC            -1
#define CODE_FAILURE_UPDATE_REQUIRED    -2

#define REQUEST_KEY_VERSION             @"version"

#define RESULT_KEY_CODE                 @"code"
#define RESULT_KEY_DESC_USER            @"userDescription"
#define RESULT_KEY_DESC_ARGUMENT        @"userDescriptionArguments"
#define RESULT_KEY_DESC_TECHNICAL       @"technicalDescription"
#define RESULT_KEY_CLIENT_OUTDATED      @"outdated"
#define RESULT_KEY_RESULT               @"result"


@implementation AbstractWSController


#pragma mark ###############################
#pragma mark Lifecycle

+ (AbstractWSController *)get {
    
    static AbstractWSController *wsInstance;
    if(!wsInstance)
        wsInstance = [self new];
    
    return wsInstance;
}


#pragma mark ###############################
#pragma mark Behaviors


- (NSURL *)serverURL {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You must override this method." userInfo:nil];
}

- (void)upgrade:(NSNumber *)button {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You must override this method." userInfo:nil];
}

- (BOOL)isSynchronous {
    
    return NO;
}

- (ASIHTTPRequest *)requestWithDictionary:(NSDictionary *)parameters method:(WSRequestMethod)method
                               completion:(void (^)(NSData *responseData))completion {
    
    inf(@"Out to %@, method: %d:\n%@", [self serverURL], method, parameters);
    ASIHTTPRequest *request = nil;
    NSData *(^loadRequest)(void) = nil;
    
    switch (method) {
        case WSRequestMethodGET_REST: {
            ASIFormDataRequest *formRequest = [[[ASIFormDataRequest alloc] initWithURL:[self serverURL]] autorelease];
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
             [formRequest encodeURL:[[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleVersionKey]]];
            
            loadRequest = ^{
                NSError *error = nil;
                NSURLResponse *response = nil;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                                                             returningResponse:&response error:&error];
                request.error = error;
                
                return responseData;
            };
            break;
        }
            
        case WSRequestMethodPOST_REST: {
            // Build the request.
            ASIFormDataRequest *formRequest = [[[ASIFormDataRequest alloc] initWithURL:[self serverURL]] autorelease];
            request = formRequest;
            
            [formRequest setPostFormat:ASIURLEncodedPostFormat];
            [formRequest setDelegate:self];
            for (NSString *key in [parameters allKeys]) {
                id value = [parameters objectForKey:key];
                if (value != [NSNull null])
                    [formRequest setPostValue:[value description] forKey:key];
            }
            [formRequest setPostValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleVersionKey] forKey:REQUEST_KEY_VERSION];
            
            loadRequest = ^{
                [request startSynchronous];
                
                return request.responseData;
            };
            break;
        }
            
        case WSRequestMethodPOST_JSON: {
            // Build the request.
            request = [[[ASIHTTPRequest alloc] initWithURL:[self serverURL]] autorelease];
            
            NSError *jsonError = nil;
            [request setPostBody:[[[[CJSONSerializer serializer] serializeDictionary:parameters error:&jsonError] mutableCopy] autorelease]];
            if (jsonError != nil) {
                err(@"JSON: %@, for request:\n%@", jsonError, request.url);
                return nil;
            }
            
            loadRequest = ^{
                [request startSynchronous];
                
                return request.responseData;
            };
            break;
        }
    }
    
    dispatch_block_t handleRequest = ^{
        NSData *responseData = loadRequest();
        if ([request isCancelled]) {
            inf(@"Cancelled: %@", request.url);
            completion(nil);
        }
        
        if (request.error)
            err(@"Failed from: %@, error: %@", request.url, request.error);
        else
//            inf(@"In from: %@, data:\n%@", request.url, [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        
        if ([self isSynchronous])
            completion(responseData);
        else
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(responseData);
            });
    };
    
    if (request) {
        if ([self isSynchronous])
            handleRequest();
        else
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), handleRequest);
    } else
        err(@"Request method not supported: %d", method);
    
    return request;
}

- (id)requestWithObject:(id)object method:(WSRequestMethod)method popupOnError:(BOOL)popupOnError allowBackOnError:(BOOL)backOnError
             completion:(void (^)(id response))completion {
    
    return [self requestWithDictionary:[object exportToCodable] method:method completion:^(NSData *responseData) {
        completion([self validateAndParseResponse:responseData popupOnError:popupOnError allowBackOnError:backOnError requires:nil]);
    }];
}


- (id)validateAndParseResponse:(NSData *)responseData popupOnError:(BOOL)popupOnError allowBackOnError:(BOOL)backOnError
                      requires:(NSString *)key, ... {
    
    if (responseData == nil || !responseData.length) {
#ifdef PEARL_UIKIT
        if (popupOnError)
            [AlertViewController showError:[PearlWSStrings get].errorWSConnection
                                backButton:backOnError];
#endif
        return nil;
    }
    
    // Trim off non-executable-JSON prefix.
    if (responseData.length >= [JSON_NON_EXECUTABLE_PREFIX length] &&
        [JSON_NON_EXECUTABLE_PREFIX isEqualToString:
         [[[NSString alloc] initWithData:[responseData subdataWithRange:NSMakeRange(0, [JSON_NON_EXECUTABLE_PREFIX length])]
                                encoding:NSUTF8StringEncoding] autorelease]])
        responseData = [responseData subdataWithRange:
                        NSMakeRange([JSON_NON_EXECUTABLE_PREFIX length], [responseData length] - [JSON_NON_EXECUTABLE_PREFIX length])];
    
    // Parse the JSON response data.
    id jsonError = nil;
    NSDictionary *responseDictionary = [NSDictionary dictionaryWithJSONData:responseData error:&jsonError];
    if (jsonError != nil) {
        err(@"JSON: %@, for response:\n%@", jsonError,
            [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
#ifdef PEARL_UIKIT
        if (popupOnError)
            [AlertViewController showError:[PearlWSStrings get].errorWSConnection
                                backButton:backOnError];
#endif
        return nil;
    }
    
    // Check whether the request was successful.
    NSNumber *resultCode = [responseDictionary objectForKey:RESULT_KEY_CODE];
    if (resultCode == nil || resultCode == (id)[NSNull null]) {
#ifdef PEARL_UIKIT
        if (popupOnError)
            [AlertViewController showError:[PearlWSStrings get].errorWSResponseInvalid backButton:backOnError];
#endif
        return nil;
    }
    
    // Check whether the client is up-to-date enough.
#ifdef PEARL_UIKIT
    NSNumber *outdatedValue = [responseDictionary objectForKey:RESULT_KEY_CLIENT_OUTDATED];
    BOOL outdated = ((id)outdatedValue != [NSNull null] && [outdatedValue boolValue]);
    if (outdated) {
        if ([resultCode intValue] == CODE_FAILURE_UPDATE_REQUIRED)
            // Required upgrade.
            [[[[AlertViewController alloc] initWithTitle:[PearlStrings get].commonTitleError
                                                 message:[PearlWSStrings get].errorWSResponseOutdatedRequired
                                              backString:[PearlStrings get].commonButtonBack
                                            acceptString:[PearlStrings get].commonButtonUpgrade
                                                callback:self :@selector(upgrade:)] showAlert] release];
        else if ([resultCode intValue] == CODE_SUCCESS)
            // Optional upgrade.
            [[[[AlertViewController alloc] initWithTitle:[PearlStrings get].commonTitleNotice
                                                 message:[PearlWSStrings get].errorWSResponseOutdatedOptional
                                              backString:[PearlStrings get].commonButtonBack
                                            acceptString:[PearlStrings get].commonButtonUpgrade
                                                callback:self :@selector(upgrade:)] showAlert] release];
    }
#endif
    
    if ([resultCode intValue] != CODE_SUCCESS && [resultCode intValue] != CODE_FAILURE_UPDATE_REQUIRED) {
        err(@"Response Code %d: %@", [resultCode intValue],
            [responseDictionary objectForKey:RESULT_KEY_DESC_TECHNICAL]);
        
        NSString *errorMessage = [responseDictionary objectForKey:RESULT_KEY_DESC_USER];
        if ((id)errorMessage != [NSNull null] && errorMessage.length) {
            id errorArgument = nil;
            NSUInteger a = 0;
            NSMutableArray *errorArguments = [[NSMutableArray alloc] initWithCapacity:1];
            while ((errorArgument = [responseDictionary objectForKey:[NSString stringWithFormat:@"%@%d",
                                                                      RESULT_KEY_DESC_ARGUMENT, a++]])
                   && errorArgument != [NSNull null])
                [errorArguments addObject:errorArgument];
            
#ifdef PEARL_UIKIT
            if (popupOnError)
                [AlertViewController showError:[NSString stringWithFormat:l(errorMessage) array:errorArguments]
                                    backButton:backOnError];
#endif
            [errorArguments release];
        }
#ifdef PEARL_UIKIT
        else if (popupOnError)
            [AlertViewController showError:[PearlWSStrings get].errorWSConnection
                                backButton:backOnError];
#endif
        
        return nil;
    }
    
    // Get the result.
    id result = [responseDictionary objectForKey:RESULT_KEY_RESULT];
    
    // Validate whether all required keys are set.  This assumes the result is a dictionary.
    va_list args;
    va_start(args, key);
    for(NSString *nextKey = key; nextKey; nextKey = va_arg(args, NSString*)) {
        id value = [result isKindOfClass:[NSDictionary class]]? [(NSDictionary *)result objectForKey:nextKey]: nil;
        if (value == nil || value == [NSNull null]) {
#ifdef PEARL_UIKIT
            if (popupOnError)
                [AlertViewController showError:[PearlWSStrings get].errorWSResponseInvalid
                                    backButton:backOnError];
#endif
            return nil;
        }
    }
    va_end(args);
    
    return result;
}

@end
