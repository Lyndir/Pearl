//
//  BoxView.m
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "BoxLayer.h"
#import "UIColor-Expanded.h"
#import "Layout.h"


@implementation BoxLayer
@synthesize color = _color;

+ (id)boxed:(CCNode *)node {

    return [self boxed:node color:ccc3to4(ccRED)];
}

+ (id)boxed:(CCNode *)node color:(ccColor4B)color {

    dbg(@"Showing bounding box for node: %@", node);
    BoxLayer *box = [BoxLayer boxWithSize:node.contentSize color:color];
    [node addChild:box];
    [node addObserver:box forKeyPath:@"contentSize" options:0 context:nil];
    
    return node;
}

+ (BoxLayer *)boxWithSize:(CGSize)aFrame color:(ccColor4B)aColor {
    
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

    DrawBoxFrom(CGPointZero, CGPointFromCGSize(self.contentSize), self.color, self.color);
}

@end
