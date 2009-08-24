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
//  MenuLayer.h
//  iLibs
//
//  Created by Maarten Billemont on 29/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "Resettable.h"
#import "ShadeLayer.h"


@interface MenuLayer : ShadeLayer <Resettable> {

@private
    NSArray                             *items;
    Menu                                *menu;
    MenuItem                            *logo;
}

@property (readwrite, copy) NSArray     *items;
@property (readwrite, retain) MenuItem  *logo;

+(MenuLayer *) menuWithItems:(MenuItem *)menuItems, ...;
+(MenuLayer *) menuWithItemsFromArray:(NSArray *)menuItems;

-(id) initWithItemsFromArray:(NSArray *)menuItems;

@end
