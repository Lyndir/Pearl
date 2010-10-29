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
//  BarLayer.h
//  iLibs
//
//  Created by Maarten Billemont on 05/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


@interface BarLayer : Sprite {

    MenuItemFont         *_menuButton;
    Menu                 *_menuMenu;
    Label                *_messageLabel;

    long                 _color, _renderColor;
    CGPoint               _showPosition;

    BOOL                 _dismissed;
}

+ (BarLayer *)barWithColor:(long)aColor position:(CGPoint)aShowPosition;
-(id) initWithColor:(long)aColor position:(CGPoint)aShowPosition;

-(void) setButtonImage:(NSString *)aFile callback:(id)target :(SEL)selector;
-(CGPoint) hidePosition;
-(void) dismiss;

-(void) message:(NSString *)msg isImportant:(BOOL)important;
-(void) message:(NSString *)msg duration:(ccTime)_duration isImportant:(BOOL)important;
-(void) dismissMessage;

@property (nonatomic, readonly) BOOL dismissed;

@end
