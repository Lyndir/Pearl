//
//  PearlBoxView.h
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


/**
 * A box layer is a plain layer that renders a bounding box.
 */
@interface PearlCCBoxLayer : CCNode {

    ccColor4B                           _color;
}

@property (nonatomic, assign) ccColor4B color;

+ (id)boxed:(CCNode *)node;
+ (id)boxed:(CCNode *)node color:(ccColor4B)color;
+ (PearlCCBoxLayer *)boxWithSize:(CGSize)aFrame at:(CGPoint)aLocation color:(ccColor4B)aColor;

- (id)initWithSize:(CGSize)aFrame at:(CGPoint)aLocation color:(ccColor4B)aColor;

@end
