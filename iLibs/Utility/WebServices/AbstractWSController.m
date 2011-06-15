//
//  AbstractWSController.m
//  iLibs
//
//  Created by Maarten Billemont on 04/06/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import "AbstractWSController.h"
#import "NSDictionary_JSONExtensions.h"
#import "NSString_NSArrayFormat.h"
#import "AlertViewController.h"
#import "ASIFormDataRequest.h"
#import "ASIHttpRequest.h"
#import "Logger.h"
#import "StringUtils.h"
#import "CJSONSerializer.h"

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

- (id)requestWithDictionary:(NSDictionary *)parameters method:(WSRequestMethod)method
                 completion:(void (^)(NSData *responseData))completion {
    
    inf(@"Out to %@, method: %d:\n%@", [self serverURL], method, parameters);
    
    switch (method) {
        case WSRequestMethodGET_REST: {
            NSMutableString *urlString = [[[self serverURL] absoluteString] mutableCopy];
            BOOL hasQuery = [urlString rangeOfString:@"?"].location != NSNotFound;
            ASIFormDataRequest *request = [[ASIFormDataRequest new] autorelease];
            
            for (NSString *key in [parameters allKeys]) {
                id value = [parameters objectForKey:key];
                if (value != [NSNull null]) {
                    [urlString appendFormat:@"%s%@=%@", hasQuery? "&": "?", 
                     [request encodeURL:key],
                     [request encodeURL:[value description]]];
                    hasQuery = YES;
                }
            }
            [urlString appendFormat:@"%s%@=%@", hasQuery? "&": "?", 
             [request encodeURL:REQUEST_KEY_VERSION],
             [request encodeURL:[[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleVersionKey]]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSError *error = nil;
                NSURLResponse *response = nil;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                                                             returningResponse:&response error:&error];
                
                if ([request isCancelled])
                    return;
                
                if (error)
                    err(@"Failed from: %@, error: %@", urlString, error);
                else
                    inf(@"In from: %@, data:\n%@", urlString, [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(responseData);
                });
            });
            
            return request;
        }
            
        case WSRequestMethodPOST_REST: {
            // Build the request.
            ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[self serverURL]] autorelease];
            [request setPostFormat:ASIURLEncodedPostFormat];
            [request setDelegate:self];
            for (NSString *key in [parameters allKeys]) {
                id value = [parameters objectForKey:key];
                if (value != [NSNull null])
                    [request setPostValue:[value description] forKey:key];
            }
            [request setPostValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleVersionKey] forKey:REQUEST_KEY_VERSION];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [request startSynchronous];
                if ([request isCancelled])
                    return;
                
                NSData *responseData = request.responseData;
                if (request.error)
                    err(@"Failed from: %@, error: %@", request.url, request.error);
                else
                    dbg(@"In from: %@, data:\n%@", request.url, [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(responseData);
                });
            });
            
            return request;
        }
            
        case WSRequestMethodPOST_JSON: {
            // Build the request.
            ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[self serverURL]] autorelease];
            NSError *jsonError = nil;
            [request setPostBody:[[[[CJSONSerializer serializer] serializeDictionary:parameters error:&jsonError] mutableCopy] autorelease]];
            if (jsonError != nil) {
                err(@"JSON: %@, for request:\n%@", jsonError, request.url);
                return nil;
            }

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [request startSynchronous];
                if ([request isCancelled])
                    return;
                
                NSData *responseData = request.responseData;
                if (request.error)
                    err(@"Failed from: %@, error: %@", request.url, request.error);
                else
                    dbg(@"In from: %@, data:\n%@", request.url, [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(responseData);
                });
            });
            
            return request;
        }
    }
    
    err(@"Request method not supported: %d", method);
    return nil;
}


- (id)validateAndParseResponse:(NSData *)responseData popupOnError:(BOOL)popupOnError allowBackOnError:(BOOL)backOnError
                      requires:(NSString *)key, ... {
    
    if (responseData == nil || !responseData.length) {
        if (popupOnError)
            [AlertViewController showConnectionErrorWithBackButton:backOnError];
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
        if (popupOnError)
            [AlertViewController showConnectionErrorWithBackButton:backOnError];
        return nil;
    }
    
    // Check whether the request was successful.
    NSNumber *resultCode = [responseDictionary objectForKey:RESULT_KEY_CODE];
    if (resultCode == nil || resultCode == (id)[NSNull null]) {
        if (popupOnError)
            [AlertViewController showError:l(@"error.response.invalid")
                                backButton:backOnError];
        return nil;
    }
    
    // Check whether the client is up-to-date enough.
    NSNumber *outdatedValue = [responseDictionary objectForKey:RESULT_KEY_CLIENT_OUTDATED];
    BOOL outdated = ((id)outdatedValue != [NSNull null] && [outdatedValue boolValue]);
    if (outdated) {
        if ([resultCode intValue] == CODE_FAILURE_UPDATE_REQUIRED)
            // Required upgrade.
            [[[[AlertViewController alloc] initWithTitle:l(@"common.title.error")
                                                 message:l(@"error.response.outdated.required")
                                              backString:l(@"common.button.back")
                                            acceptString:l(@"common.button.upgrade")
                                                callback:self :@selector(upgrade:)] showAlert] release];
        else if ([resultCode intValue] == CODE_SUCCESS)
            // Optional upgrade.
            [[[[AlertViewController alloc] initWithTitle:l(@"common.title.notice")
                                                 message:l(@"error.response.outdated.optional")
                                              backString:l(@"common.button.back")
                                            acceptString:l(@"common.button.upgrade")
                                                callback:self :@selector(upgrade:)] showAlert] release];
    }
    
    if ([resultCode intValue] != CODE_SUCCESS && [resultCode intValue] != CODE_FAILURE_UPDATE_REQUIRED) {
        err(@"Response Code %d:\n%@", [resultCode intValue],
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
            
            if (popupOnError)
                [AlertViewController showError:[NSString stringWithFormat:l(errorMessage) array:errorArguments]
                                    backButton:backOnError];
            [errorArguments release];
        } else
            if (popupOnError)
                [AlertViewController showConnectionErrorWithBackButton:backOnError];
        
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
            if (popupOnError)
                [AlertViewController showError:l(@"error.response.invalid")
                                    backButton:backOnError];
            return nil;
        }
    }
    va_end(args);
    
    return result;
}

@end
