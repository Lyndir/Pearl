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
//  ShadeTo.m
//  iLibs
//
//  Created by Maarten Billemont on 22/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "ShadeTo.h"
#import "AbstractAppDelegate.h"


@implementation ShadeTo


+(ShadeTo *) actionWithDuration:(ccTime)_duration color:(long)_color {
    
    return [[[ShadeTo alloc] initWithDuration:_duration color:_color] autorelease];
}


-(ShadeTo *) initWithDuration:(ccTime)_duration color:(long)_color {
    
    if(!(self = [super initWithDuration: _duration]))
        return self;
    
    endCol = _color;
    
    return self;
}


- (void)startWithTarget:(CocosNode *)aTarget {
    
    [super startWithTarget:aTarget];    
    
    if(![target conformsToProtocol:@protocol(CocosNodeRGBA)])
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"ShadeTo action target does not conform to CocosNodeRGBA" userInfo:nil];
    
    startCol    = [(CocosNode< CocosNodeRGBA> *) target r] << 24
                | [(CocosNode< CocosNodeRGBA> *) target g] << 16
                | [(CocosNode< CocosNodeRGBA> *) target b] << 8
                | [(CocosNode< CocosNodeRGBA> *) target opacity];
}


-(void) update: (ccTime) dt {
    
    const GLubyte *s = (GLubyte *)&startCol, *e = (GLubyte *)&endCol;
    
    [(id)target setRGB: (int) (s[3] * (1 - dt)) + (int) (e[3] * dt)
                      : (int) (s[2] * (1 - dt)) + (int) (e[2] * dt)
                      : (int) (s[1] * (1 - dt)) + (int) (e[1] * dt)];
    [(id<CocosNodeRGBA>)target setOpacity: (int) (s[0] * (1 - dt)) + (int) (e[0] * dt)];
}


-(void) dealloc {
    
    [super dealloc];
}


@end
