//
//  MenuItemBlock.m
//  Pearl
//
//  Created by Maarten Billemont on 08/06/11.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "MenuItemBlock.h"
#import "Config.h"


@implementation MenuItemBlock



+ (MenuItemBlock *)itemWithSize:(NSUInteger)size target:(id)target selector:(SEL)selector {
    
    return [[[MenuItemBlock alloc] initWithSize:size target:target selector:selector] autorelease];
}

- (id)initWithSize:(NSUInteger)size target:(id)target selector:(SEL)selector {
    
    if (!(self = [super initWithTarget:target selector:selector]))
        return nil;
    
    self.contentSize = CGSizeMake(size, size);
    
    return self;
}

- (void)draw {
    
    if (!self.isEnabled) {
        CGPoint to = CGPointFromCGSize(self.contentSizeInPixels);
        DrawLinesTo(CGPointZero, &to, 1, ccc3to4(ccWHITE), 5);
    }
}

@end
