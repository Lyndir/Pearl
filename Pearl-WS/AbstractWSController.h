//
//  AbstractWSController.h
//  Pearl
//
//  Created by Maarten Billemont on 04/06/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    /** Submit the parameters in a www-form encoded HTTP-GET request. */
    WSRequestMethodGET_REST,
    /** Submit the parameters in a www-form encoded HTTP-POST request. */
    WSRequestMethodPOST_REST,
    /** Submit the parameters in a JSON encoded HTTP-POST request. */
    WSRequestMethodPOST_JSON,
} WSRequestMethod;

typedef enum {
    JSONResultCodeSuccess = 0,
    JSONResultCodeGenericFailure = -1,
    JSONResultCodeUpdateRequired = -2,
} JSONResultCode;

@interface JSONResult : NSObject {

    JSONResultCode  _code;
    BOOL            _outdated;
    NSString        *_userDescription;
    NSArray         *_userDescriptionArguments;
    NSString        *_technicalDescription;
    id              _result;
}

@property (nonatomic, assign) JSONResultCode    code;
@property (nonatomic, retain) NSString          *userDescription;
@property (nonatomic, retain) NSArray           *userDescriptionArguments;
@property (nonatomic, retain) NSString          *technicalDescription;
@property (nonatomic, assign) BOOL              outdated;
@property (nonatomic, retain) id                result;

- (id)initWithDictionary:(NSDictionary *)aDictionary;

@end

/**
 * The controller that manages the communication with JSON endpoints.
 */
@interface AbstractWSController : NSObject {

    BOOL            _suppressOutdatedWarning;
}

@property (nonatomic, assign) BOOL              suppressOutdatedWarning;

#pragma mark ###############################
#pragma mark Lifecycle

/** Obtain the webservice controller instance. */
+ (AbstractWSController *)get;

/** Reset the active session and all warnings issued in it. */
- (void)reset;

/** Invoke a WS request, submitting the parameters encoded with the given method.
 *
 * @param parameters
 *        The parameters to send to the server.
 * @param method
 *        The method to use for encoding and submitting the request to the server.
 * @param completion
 *        The block of code to execute on completion of the operation. The block takes one parameter: the body data of the server's response
 *        or nil if the request or reading of the response failed.
 * @return The object responsible for handling this request while it's in progress.
 */
- (id)requestWithDictionary:(NSDictionary *)parameters method:(WSRequestMethod)method
                 completion:(void (^)(NSData *responseData))completion;


/** Invoke a WS request, serializing the given object according to the given method.
 *
 * @param object
 *        The object to serialize and send to the server.
 * @param method
 *        The method to use for encoding and submitting the request to the server.
 * @param popupOnError
 *        Show popup dialogs when parsing errors occur, or the response contains a failure code.
 * @param backOnError
 *        Show a back button on error popups, allowing the user to dismiss the popup without resetting the UI.
 * @param completion
 *        The block of code to execute on completion of the operation. The block takes two parameters:  A boolean indicating whether the
 *        response was successfully parsed in and indicates a successful result, and the JSON response object if it was parsed successfully.
 * @return The object responsible for handling this request while it's in progress.
 */
- (id)requestWithObject:(id)object method:(WSRequestMethod)method popupOnError:(BOOL)popupOnError allowBackOnError:(BOOL)backOnError
             completion:(void (^)(BOOL success, JSONResult *response))completion;

/**
 * Check whether the given response data is valid and parse its JSON datastructure.
 *
 * @param responseData
 *        The JSON data that should be validated and parsed into an object.
 * @param response
 *        A pointer to where the response object should become available.  nil if the response data could not be parsed.
 * @param popupOnError
 *        Show popup dialogs when parsing errors occur, or the response contains a failure code.
 * @param backOnError
 *        Show a back button on error popups, allowing the user to dismiss the popup without resetting the UI.
 * @param requires
 *        A list of keys that are required to be present in the result object.
 * @return A boolean indicating whether the response was successfully parsed, has a successful code and passed validation.
 */
- (BOOL)validateAndParseResponse:(NSData *)responseData into:(JSONResult **)response popupOnError:(BOOL)popupOnError allowBackOnError:(BOOL)backOnError
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

/**
 * Override this method to make the operations synchronous.  Defaults to NO.
 */
- (BOOL)isSynchronous;

@end
