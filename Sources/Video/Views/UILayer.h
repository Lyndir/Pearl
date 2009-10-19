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
//  UILayer.h
//  iLibs
//
//  Created by Maarten Billemont on 08/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//


@interface UILayer : ColorLayer {
    
    Label                                   *messageLabel;
    NSMutableArray                          *messageQueue, *callbackQueue;
    
    RotateTo                                *rotateAction;
    UIAccelerationValue                     accelX, accelY, accelZ;
}

-(void) rotateTo:(float)aRotation;

-(void) message:(NSString *)msg;
-(void) message:(NSString *)msg callback:(id)target :(SEL)selector;

@end
