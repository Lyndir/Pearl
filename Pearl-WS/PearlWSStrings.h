//
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import <Foundation/Foundation.h>
#import "Strings.h"


@interface PearlWSStrings : Strings {

}

+ (PearlWSStrings *)get;

@property (nonatomic, readonly) NSString *errorWSConnection;
@property (nonatomic, readonly) NSString *errorWSResponseInvalid;
@property (nonatomic, readonly) NSString *errorWSResponseFailed;
@property (nonatomic, readonly) NSString *errorWSResponseOutdatedRequired;
@property (nonatomic, readonly) NSString *errorWSResponseOutdatedOptional;

@end
