/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
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

+ (PearlWSStrings *)get;

@property (nonatomic, readonly) NSString *errorWSConnection;
@property (nonatomic, readonly) NSString *errorWSResponseInvalid;
@property (nonatomic, readonly) NSString *errorWSResponseFailed;
@property (nonatomic, readonly) NSString *errorWSResponseOutdatedRequired;
@property (nonatomic, readonly) NSString *errorWSResponseOutdatedOptional;

@end
