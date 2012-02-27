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
//  PearlCCFlickLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 22/10/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCScrollLayer.h"


@interface PearlCCFlickLayer : CCLayer<PearlCCScrollLayerDelegate> {

    PearlCCScrollLayer *_content;

    CCMenuItem             *_right, *_left;
}

+ (id)flickSprites:(CCSprite *)firstSprite, ... NS_REQUIRES_NIL_TERMINATION;
+ (id)flickSpritesFromArray:(NSArray *)sprites;

- (id)initWithSprites:(CCSprite *)firstSprite, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithSpritesFromArray:(NSArray *)sprites;

@end
