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
//  AbstractWSController.h
//  Pearl
//
//  Created by Maarten Billemont on 04/06/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

__BEGIN_DECLS
typedef enum {
    /** Submit the parameters in a www-form encoded HTTP-GET request. */
     PearlWSRequestMethodGET_REST,
    /** Submit the parameters in a www-form encoded HTTP-POST request. */
     PearlWSRequestMethodPOST_REST,
    /** Submit the parameters in a JSON encoded HTTP-POST request. */
     PearlWSRequestMethodPOST_JSON,
} PearlWSRequestMethod;

typedef enum {
    PearlJSONResultCodeSuccess        = 0,
    PearlJSONResultCodeGenericFailure = -1,
    PearlJSONResultCodeUpdateRequired = -2,
} PearlJSONResultCode;
__END_DECLS

@interface PearlJSONResult : NSObject {

    PearlJSONResultCode _code;
    BOOL                _outdated;
    NSString *_userDescription;
    NSArray  *_userDescriptionArguments;
    NSString *_technicalDescription;
    id _result;
}

@property (nonatomic, assign) PearlJSONResultCode code;
@property (nonatomic, retain) NSString *userDescription;
@property (nonatomic, retain) NSArray  *userDescriptionArguments;
@property (nonatomic, retain) NSString *technicalDescription;
@property (nonatomic, assign) BOOL outdated;
@property (nonatomic, retain) id   result;

- (id)initWithDictionary:(NSDictionary *)aDictionary;

@end

/**
 * The controller that manages the communication with JSON endpoints.
 */
@interface PearlWSController : NSObject {

    BOOL _suppressOutdatedWarning;
}

@property (nonatomic, assign) BOOL suppressOutdatedWarning;

#pragma mark ###############################
#pragma mark Lifecycle

/** Obtain the webservice controller instance. */
+ (instancetype)get;

/** Reset the active session and all warnings issued in it. */
- (void)reset;

/** Invoke a WS request, submitting the parameters encoded with the given method.
 *
 * @param parameters
 *        The parameters to send to the server.
 * @param method
 *        The method to use for encoding and submitting the request to the server.
 * @param completion
 *        The block of code to execute on completion of the operation. The block takes two parameters: the body data of the server's response
 *        or nil if the request or reading of the response failed, and the error object if an error occurred.  When the request is cancelled,
 *        both the response and the error are nil.
 * @return The object responsible for handling this request while it's in progress.
 */
- (id)requestWithDictionary:(NSDictionary *)parameters method:(PearlWSRequestMethod)method
                 completion:(void (^)(NSData *responseData, NSError *connectionError))completion;


/** Invoke a WS request, serializing the given object according to the given method.
 *
 * @param object
 *        The object to serialize and send to the server.
 * @param method
 *        The method to use for encoding and submitting the request to the server.
 * @param popupOnError
 *        Show popup dialogs when parsing errors occur, or the response contains a failure code.
 * @param completion
 *        The block of code to execute on completion of the operation. The block takes three parameters:  A boolean indicating whether the
 *        response was successfully parsed in and indicates a successful result, the JSON response object if it was parsed successfully,
 *        and the error in case an error occurred. When the request is cancelled, both the response and the error are nil.
 * @return The object responsible for handling this request while it's in progress.
 */
- (id)requestWithObject:(id)object method:(PearlWSRequestMethod)method popupOnError:(BOOL)popupOnError
             completion:(void (^)(BOOL success, PearlJSONResult *response, NSError *connectionError))completion;

/**
 * Check whether the given response data is valid and parse its JSON datastructure.
 *
 * @param responseData
 *        The JSON data that should be validated and parsed into an object.
 * @param response
 *        A pointer to where the response object should become available.  nil if the response data could not be parsed.
 * @param popupOnError
 *        Show popup dialogs when parsing errors occur, or the response contains a failure code.
 * @param requires
 *        A list of keys that are required to be present in the result object.
 * @return A boolean indicating whether the response was successfully parsed, has a successful code and passed validation.
 */
- (BOOL)validateAndParseResponse:(NSData *)responseData into:(PearlJSONResult **)response popupOnError:(BOOL)popupOnError
                        requires:(NSString *)key, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Override this method to provide the URL of the server's JSON webservice endpoint.
 */
- (NSURL *)serverURL;

/**
 * Invoked when a user presses the Upgrade button on an alert resulting from a web service call indicating that the client is outdated.
 */
- (void)upgrade;

/**
 * Override this method to make the operations synchronous.  Defaults to NO.
 */
- (BOOL)isSynchronous;

@end
