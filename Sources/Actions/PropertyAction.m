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
//  AnimateProperty.m
//  Deblock
//
//  Created by Maarten Billemont on 21/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PropertyAction.h"


@implementation PropertyAction

+ (id)actionWithDuration:(ccTime)aDuration key:(NSString *)aKey from:(NSNumber *)aFrom to:(NSNumber *)aTo {

    return [[[[self class] alloc] initWithDuration:aDuration key:aKey from:aFrom to:aTo] autorelease];
}


- (id)initWithDuration:(ccTime)aDuration key:(NSString *)aKey from:(NSNumber *)aFrom to:(NSNumber *)aTo {
    
    if (!(self = [super initWithDuration:aDuration]))
        return nil;
    
    key     = [aKey copy];
    from    = [aFrom copy];
    to      = [aTo copy];
    
    return self;
}

- (void)startWithTarget:(CocosNode *)aTarget {
    
    [super startWithTarget:aTarget];
    
    if (from)
        [self.target setValue:from forKey:key];
    
    delta = [to floatValue] - [from floatValue];
}

- (void) update:(ccTime) dt {
    
    [self.target setValue:[NSNumber numberWithFloat:[to floatValue] - delta * (1 - dt)] forKey:key];
}

- (IntervalAction *) reverse
{
	return [[self class] actionWithDuration:self.duration key:key from:to to:from];
}

@end
