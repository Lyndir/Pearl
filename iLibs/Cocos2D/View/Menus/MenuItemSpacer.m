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
//  MenuItemSpacer.m
//  iLibs
//
//  Created by Maarten Billemont on 02/03/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "MenuItemSpacer.h"
#import "Config.h"


@interface MenuItemSpacer ()

@property (readwrite, assign) CGFloat  height;

@end


@implementation MenuItemSpacer

@synthesize height = _height;

+(id) spacerSmall {
    
    return [[[self alloc] initSmall] autorelease];
}

+(id) spacerNormal {
    
    return [[[self alloc] initNormal] autorelease];
}

+(id) spacerLarge {
    
    return [[[self alloc] initLarge] autorelease];
}

-(id) initSmall {
    
    return [self initWithHeight:[[Config get].smallFontSize intValue]];
}

-(id) initNormal {
    
    return [self initWithHeight:[[Config get].fontSize intValue]];
}

-(id) initLarge {
    
    return [self initWithHeight:[[Config get].largeFontSize intValue]];
}


-(id) initWithHeight:(CGFloat)aHeight {
    
    if(!(self = [super initWithTarget:nil selector:nil]))
        return self;
    
    self.height = aHeight;
    [self setIsEnabled:NO];
    
    return self;
}


-(CGRect) rect {
    
	return CGRectMake(self.position.x, self.position.y - self.height / 2, self.position.x, self.position.y + self.height / 2);
}


-(CGSize) contentSize {
    
	return CGSizeMake(0, self.height);
}


@end
