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


#import "PearlWSStrings.h"


@implementation PearlWSStrings

- (id)init {

    return [super initWithTable:@"PearlWS"];
}

+ (PearlWSStrings *)get {

    static PearlWSStrings *pearlWSStrings = nil;
    if (pearlWSStrings == nil)
        pearlWSStrings = [PearlWSStrings new];

    return pearlWSStrings;
}

@dynamic errorWSConnection;
@dynamic errorWSResponseInvalid;
@dynamic errorWSResponseFailed;
@dynamic errorWSResponseOutdatedRequired;
@dynamic errorWSResponseOutdatedOptional;

@end
