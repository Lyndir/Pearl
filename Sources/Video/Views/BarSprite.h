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
//  BarSprite.h
//  iLibs
//
//  Created by Maarten Billemont on 27/06/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BarSprite : Layer {

@private
    Texture2D           *head, **body, *tail;

    CGFloat             age;
    NSUInteger          bodyFrame, bodyFrames;
    
    BOOL                animatedTargetting;
    ccTime              smoothTimeElapsed;
    CGPoint             target;
    
    CGPoint             current;
    CGFloat             currentLength;
    
    CGSize              textureSize;
}


#pragma mark ###############################
#pragma mark Lifecycle

- (id) initWithHead:(NSString *)bundleHeadReference body:(NSString *)bundleBodyReference withFrames:(NSUInteger)bodyFrameCount tail:(NSString *)bundleTailReference animatedTargetting:(BOOL)anAnimatedTargetting;


@property (readwrite, assign) CGPoint   target;
@property (readwrite, assign) CGSize    textureSize;

@end
