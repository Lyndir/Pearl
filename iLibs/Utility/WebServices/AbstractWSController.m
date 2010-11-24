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
#import "NSData_MBBase64.h"
#import "AlertViewController.h"
#import "ASIFormDataRequest.h"
#import "Logger.h"
#import "StringUtils.h"

#define JSON_NON_EXECUTABLE_PREFIX      @")]}'\n"

#define RESULT_KEY_CODE                 @"code"
#define RESULT_KEY_DESC_USER            @"userDescription"
#define RESULT_KEY_DESC_TECHNICAL       @"technicalDescription"
#define RESULT_KEY_DESC_ARGUMENT        @"userDescriptionArguments"
#define RESULT_KEY_CLIENT_OUTDATED      @"outdated"
#define RESULT_KEY_RESULT               @"result"


@implementation AbstractWSController


#pragma mark ###############################
#pragma mark Lifecycle

- (id)init {
    
    if(!(self = [super init]))
        return self;
    
    responseCallbackStore = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    return self;
}


+ (AbstractWSController *)get {
    
    static AbstractWSController *wsInstance;
    if(!wsInstance)
        wsInstance = [self new];
    
    return wsInstance;
}


- (void)dealloc {
    
    [responseCallbackStore release];
    responseCallbackStore = nil;
    
    [super dealloc];
}


#pragma mark ###############################
#pragma mark Behaviors


- (NSURL *)serverURL {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You must override this method." userInfo:nil];
}

- (void)upgrade:(NSNumber *)button {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"You must override this method." userInfo:nil];
}

- (id)getRequestFromDictionary:(NSDictionary *)parameters
                    withTarget:(id)target callback:(SEL)callback {

    [[Logger get] inf:@"Making WS request with parameters:\n%@", parameters];

    NSMutableString *urlString = [[[self serverURL] absoluteString] mutableCopy];
    BOOL hasQuery = [urlString rangeOfString:@"?"].location != NSNotFound;
    ASIFormDataRequest *dummyRequest = [[ASIFormDataRequest new] autorelease];
    
    for (NSString *key in [parameters allKeys]) {
        [urlString appendFormat:@"%s%@=%@", hasQuery? "&": "?", 
         [dummyRequest encodeURL:key], [dummyRequest encodeURL:[[parameters objectForKey:key] description]]];
        hasQuery = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                                                     returningResponse:&response error:&error];
        
        if ([dummyRequest isCancelled])
            return;

        if (error)
            [[Logger get] err:@"WS request failed: %@", error];

        [target performSelectorOnMainThread:callback withObject:responseData waitUntilDone:NO];
    });

    return dummyRequest;
}

- (id)postRequestFromDictionary:(NSDictionary *)parameters
                     withTarget:(id)target callback:(SEL)callback {
    
    [[Logger get] inf:@"Making WS request with parameters:\n%@", parameters];
    
    // Build the request.
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[self serverURL]];
    [request setPostFormat:ASIURLEncodedPostFormat];
    [request setDelegate:self];
    for (NSString *key in [parameters allKeys])
        [request setPostValue:[[parameters objectForKey:key] description] forKey:key];
    
    // Build the callback invocation.
    NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:callback];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:[target retain]];
    [invocation setSelector:callback];
    
    // Remember the callback invocation using the request pointer as key.
    NSValue *requestKey = [NSValue valueWithPointer:request];
    [responseCallbackStore setObject:invocation forKey:requestKey];
    
    [request startAsynchronous];
    
    return request;
}


- (id)validateAndParseResponse:(NSData *)responseData popupOnError:(BOOL)popupOnError allowBackOnError:(BOOL)backOnError
                      requires:(NSString *)key, ... {
    
    if (responseData == nil) {
        if (popupOnError)
            [AlertViewController showConnectionErrorWithBackButton:backOnError];
        return nil;
    }
    
    // Trim off non-executable-JSON prefix.
    if ([[[NSString alloc] initWithData:[responseData subdataWithRange:NSMakeRange(0, [JSON_NON_EXECUTABLE_PREFIX length])]
                               encoding:NSUTF8StringEncoding] isEqualToString:JSON_NON_EXECUTABLE_PREFIX])
        responseData = [responseData subdataWithRange:
                        NSMakeRange([JSON_NON_EXECUTABLE_PREFIX length], [responseData length] - [JSON_NON_EXECUTABLE_PREFIX length])];
    
    // Parse the JSON response data.
    id jsonError = nil;
    NSDictionary *responseDictionary = [NSDictionary dictionaryWithJSONData:responseData error:&jsonError];
    if (jsonError != nil) {
        [[Logger get] err:@"Error: JSON parsing failed: %@", jsonError];
        if (popupOnError)
            [AlertViewController showConnectionErrorWithBackButton:backOnError];
        return nil;
    }
    
    // Check whether the request was successful.
    NSNumber *resultCode = [responseDictionary objectForKey:RESULT_KEY_CODE];
    if (resultCode == nil || resultCode == (id)[NSNull null]) {
        if (popupOnError)
            [AlertViewController showError:l(@"error.response.invalid")
                                backButton:NO];
        return nil;
    }
    
    // Check whether the client is up-to-date enough.
    NSNumber *outdatedValue = [responseDictionary objectForKey:RESULT_KEY_CLIENT_OUTDATED];
    BOOL outdated = ((id)outdatedValue != [NSNull null] && [outdatedValue boolValue]);
    if (outdated) {
        if ([resultCode intValue] != 0)
            // Required upgrade.
            [[[[AlertViewController alloc] initWithTitle:l(@"global.error")
                                                 message:l(@"error.response.clientOutdated.required")
                                              backString:l(@"global.button.back")
                                            acceptString:l(@"global.button.upgrade")
                                                callback:self :@selector(upgrade:)] showAlert] release];
        else
            // Optional upgrade.
            [[[[AlertViewController alloc] initWithTitle:l(@"global.notice")
                                                 message:l(@"error.response.clientOutdated.optional")
                                              backString:l(@"global.button.back")
                                            acceptString:l(@"global.button.upgrade")
                                                callback:self :@selector(upgrade:)] showAlert] release];
    }
    
    if ([resultCode intValue] != 0) {
        [[Logger get] err:@"Error: WS request failed: Code %d: %@",
         [resultCode intValue], [responseDictionary objectForKey:RESULT_KEY_DESC_TECHNICAL]];
        
        if (!outdated) {
            // If outdated, a message has already been shown.

            NSString *errorMessage = [responseDictionary objectForKey:RESULT_KEY_DESC_USER];
            if ((id)errorMessage != [NSNull null] && errorMessage.length) {
                id errorArgument;
                NSUInteger a = 0;
                NSMutableArray *errorArguments = [[NSMutableArray alloc] initWithCapacity:1];
                while ((errorArgument = [responseDictionary objectForKey:[NSString stringWithFormat:@"%@%d",
                                                                          RESULT_KEY_DESC_ARGUMENT, a++]])
                       && errorArgument != [NSNull null])
                    [errorArguments addObject:errorArgument];
                
                if (popupOnError)
                    [AlertViewController showError:[NSString stringWithFormat:l(errorMessage) array:errorArguments]
                                        backButton:backOnError];
            } else
                if (popupOnError)
                    [AlertViewController showConnectionErrorWithBackButton:backOnError];
        }
        
        return nil;
    }
    
    // Get the result.
    id result = [responseDictionary objectForKey:RESULT_KEY_RESULT];
    
    // Validate whether all required keys are set.  This assumes the result is a dictionary.
    va_list args;
    va_start(args, key);
    for(NSString *nextKey = key; nextKey; nextKey = va_arg(args, NSString*)) {
        id value = [result isKindOfClass:[NSDictionary class]]? [result objectForKey:nextKey]: nil;
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


- (void)abortRequest:(ASIHTTPRequest *)request {
    
    NSValue *requestKey = [NSValue valueWithPointer:request];
    NSInvocation *invocation = [[responseCallbackStore objectForKey:requestKey] retain];
    [responseCallbackStore removeObjectForKey:requestKey];
    if (!invocation)
        // Already handled.
        return;
    
    [request cancel];
    [[Logger get] err:@"WS request aborted: %@", [request url]];
    
    [request release];
    [[invocation target] release];
    [invocation release];
}


- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSValue *requestKey = [NSValue valueWithPointer:request];
    NSInvocation *invocation = [[responseCallbackStore objectForKey:requestKey] retain];
    [responseCallbackStore removeObjectForKey:requestKey];
    if (!invocation)
        // Already handled.
        return;
    
    [[Logger get] err:@"WS request failed: %@", [request error]];
    
    id nilResponseData = nil;
    if ([[invocation methodSignature] numberOfArguments] > 2)
        [invocation setArgument:&nilResponseData atIndex:2];
    [invocation invoke];
    
    [request release];
    [[invocation target] release];
    [invocation release];
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSValue *requestKey = [NSValue valueWithPointer:request];
    NSInvocation *invocation = [[responseCallbackStore objectForKey:requestKey] retain];
    [responseCallbackStore removeObjectForKey:requestKey];
    if (!invocation)
        // Already handled.
        return;
    
    NSData *responseData = [request responseData];
    if ([[invocation methodSignature] numberOfArguments] > 2)
        [invocation setArgument:&responseData atIndex:2];
    [invocation invoke];
    
    [request release];
    [[invocation target] release];
    [invocation release];
}


@end
