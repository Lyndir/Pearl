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


@interface PropertyAction ()

@property (readwrite, copy) NSString     *key;
@property (readwrite, retain) NSNumber     *from;
@property (readwrite, retain) NSNumber     *to;

@property (readwrite, assign) float        delta;

@end


@implementation PropertyAction

@synthesize key = _key;
@synthesize from = _from, to = _to;
@synthesize delta = _delta;

+ (id)actionWithDuration:(ccTime)aDuration key:(NSString *)aKey from:(NSNumber *)aFrom to:(NSNumber *)aTo {

    return [[[[self class] alloc] initWithDuration:aDuration key:aKey from:aFrom to:aTo] autorelease];
}


- (id)initWithDuration:(ccTime)aDuration key:(NSString *)aKey from:(NSNumber *)aFrom to:(NSNumber *)aTo {
    
    if (!(self = [super initWithDuration:aDuration]))
        return nil;
    
    self.key     = aKey;
    self.from    = aFrom;
    self.to      = aTo;
    
    return self;
}

- (void)startWithTarget:(CocosNode *)aTarget {
    
    [super startWithTarget:aTarget];
    
    if (self.from)
        [self.target setValue:self.from forKey:self.key];
    
    self.delta = [self.to floatValue] - [self.from floatValue];
}

- (void) update:(ccTime) dt {
    
    [self.target setValue:[NSNumber numberWithFloat:[self.to floatValue] - self.delta * (1 - dt)] forKey:self.key];
}

- (IntervalAction *) reverse
{
	return [[self class] actionWithDuration:self.duration key:self.key from:self.to to:self.from];
}

- (void)dealloc {

    self.key = nil;
    self.from = nil;
    self.to = nil;

    [super dealloc];
}

@end
