//
//  AbstractWSController.h
//  iLibs
//
//  Created by Maarten Billemont on 04/06/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * The controller that manages the communication with JSON endpoints.
 */
@interface AbstractWSController : NSObject {
   
@private
    NSMutableDictionary         *responseCallbackStore;
}

#pragma mark ###############################
#pragma mark Lifecycle

/** Obtain the webservice controller instance. */
+ (AbstractWSController *)get;


/** Abort an active request.
 *
 * @param   request
 *          The object returned to you as a result of the request method of this class you wish to abort.
 */
- (void)abortRequest:(id)request;

/**
 * Check whether the given response data is valid and parse its JSON datastructure.
 *
 * @return  A dictionary reflecting the JSON data structure or nil if the response isn't valid.
 */
- (NSDictionary *)validateAndParseResponse:(NSData *)responseData allowBackOnError:(BOOL)backOnError
                                  requires:(NSString *)key, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Override this method to provide the URL of the server's JSON webservice endpoint.
 */
- (NSURL *)serverURL;

/**
 * Invoked when a user presses the Upgrade button on an alert resulting from a web service call indicating that the client is outdated.
 * @param button The index of the button that was used to dismiss the alert (base 1).
 */
- (void)upgrade:(NSNumber *)button;

@end
