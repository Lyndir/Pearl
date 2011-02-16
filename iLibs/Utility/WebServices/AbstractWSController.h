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


/** Invoke a WS request using HTTP-GET.
 *
 * @param parameters
 *        The parameters to send to the server using JSON.
 * @param target
 *        The object to invoke the callback onto after the response has been received.
 * @param callback
 *        The callback to invoke on the target object after the server's response has been received.  The callback may take one parameter
 *        which will be set to the body data of the server's response or nil if the request or reading the response failed.
 */
- (id)getRequestFromDictionary:(NSDictionary *)parameters
                    withTarget:(id)target callback:(SEL)callback;

/** Invoke a WS request using HTTP-POST.
 *
 * @param parameters
 *        The parameters to send to the server using JSON.
 * @param target
 *        The object to invoke the callback onto after the response has been received.
 * @param callback
 *        The callback to invoke on the target object after the server's response has been received.  The callback may take one parameter
 *        which will be set to the body data of the server's response or nil if the request or reading the response failed.
 */
- (id)postRequestFromDictionary:(NSDictionary *)parameters
                     withTarget:(id)target callback:(SEL)callback;
    
/**
 * Check whether the given response data is valid and parse its JSON datastructure.
 *
 * @param responseData
 *        The JSON data that should be validated and parsed into an object.
 * @param popupOnError
 *        Show popup dialogs when parsing errors occur, or the response contains a failure code.
 * @param backOnError
 *        Show a back button on error popups, allowing the user to dismiss the popup without resetting the UI.
 * @param requires
 *        A list of keys that are required to be present in the result object.
 * @return  An object reflecting the JSON data structure contained within the response's result or nil if the response isn't valid.
 */
- (id)validateAndParseResponse:(NSData *)responseData popupOnError:(BOOL)popupOnError allowBackOnError:(BOOL)backOnError
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
