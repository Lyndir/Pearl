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
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import <Foundation/Foundation.h>
#import "PearlAbstractStrings.h"


@interface PearlWSStrings : PearlAbstractStrings {

}

+ (instancetype)get;

@property (nonatomic, readonly) NSString *errorWSConnection;
@property (nonatomic, readonly) NSString *errorWSResponseInvalid;
@property (nonatomic, readonly) NSString *errorWSResponseFailed;
@property (nonatomic, readonly) NSString *errorWSResponseOutdatedRequired;
@property (nonatomic, readonly) NSString *errorWSResponseOutdatedOptional;

@end
