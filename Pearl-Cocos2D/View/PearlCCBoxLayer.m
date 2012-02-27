//
//  PearlBoxView.m
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCBoxLayer.h"
#import "PearlLayout.h"
#import "PearlGLUtils.h"


@implementation PearlCCBoxLayer
@synthesize color = _color;

+ (id)boxed:(CCNode *)node {

    return [self boxed:node color:ccc3to4(ccRED)];
}

+ (id)boxed:(CCNode *)node color:(ccColor4B)color {

    dbg(@"Showing bounding box for node: %@", node);
    PearlCCBoxLayer *box = [PearlCCBoxLayer boxWithSize:node.contentSize color:color];
    [node addChild:box];
    [node addObserver:box forKeyPath:@"contentSize" options:0 context:nil];
    
    return node;
}

+ (PearlCCBoxLayer *)boxWithSize:(CGSize)aFrame color:(ccColor4B)aColor {
    
    return [[[self alloc] initWithSize:aFrame color:aColor] autorelease];
}

- (id)initWithSize:(CGSize)size color:(ccColor4B)aColor {
    
    if (!(self = [super init]))
        return self;
    
    self.contentSize = size;
    self.color = aColor;
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.parent && [keyPath isEqualToString:@"contentSize"])
        self.contentSize = self.parent.contentSize;
}

- (void)draw {

    ccColor4B backColor = self.color;
    backColor.a = 0x33;
    
    DrawBoxFrom(CGPointZero, CGPointFromCGSize(self.contentSizeInPixels), backColor, backColor);
    DrawBorderFrom(CGPointZero, CGPointFromCGSize(self.contentSizeInPixels), self.color, 1.0f);
}

@end
