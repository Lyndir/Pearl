//
//  CCDebug.m
//  Deblock
//
//  Created by Maarten Billemont on 03/04/11.
//  Copyright 2011 Lhunath. All rights reserved.
//

#import "CCDebug.h"
#import "StringUtils.h"
#import "JRSwizzle.h"


static NSMutableDictionary *drawOrder_CCDebug;
static NSUInteger order_CCDebug;

@interface Activity : NSObject {
@private
    NSInteger                               index;
    NSString                                *lastDescription;
}

@property (nonatomic, retain) NSString      *lastDescription;

+ (Activity *)activity;

- (char)activityStateWithDescription:(NSString *)description;

@end

@interface CCNode (CCDebug)

- (void)draw_CCDebug;

@end

@implementation CCDebug

static NSMutableDictionary *nodeActivity;

+ (void)initialize {
    
    NSError *error = nil;
    [CCNode jr_swizzleMethod:@selector(draw) withMethod:@selector(draw_CCDebug) error:&error];
    if (error)
        dbg(@"Swizzling error: %@", error);
}

+ (void)printStateForScene:(CCScene *)scene {

    [self printStateForNode:scene indent:0];
}

+ (void)printStateForNode:(CCNode *)node indent:(NSUInteger)indent {
    
    PearlLogger *logger = [PearlLogger get];
    
    NSValue *nodeValue = [NSValue valueWithPointer:node];
    if (nodeActivity == nil)
        nodeActivity = [[NSMutableDictionary alloc] init];
    Activity *activity = [nodeActivity objectForKey:nodeValue];
    if (activity == nil)
        [nodeActivity setObject:activity = [Activity activity] forKey:nodeValue];
    
    NSString *nodeDescription = [self describe:node];
    char activityState = [activity activityStateWithDescription:nodeDescription];

    NSNumber *drawOrder = [drawOrder_CCDebug objectForKey:nodeValue];

    [logger dbg:@"%*s%@. [%c] %@", 4 * indent, "", drawOrder? [drawOrder description]: @"x", activityState, nodeDescription];
    for (CCNode *child in node.children)
        [self printStateForNode:child indent:indent + 1];
}

+ (NSString *)describe:(CCNode *)node {

    return [NSString stringWithFormat:@"z: %d, %@", node.zOrder, [node description]];
}

@end

@implementation Activity

@synthesize lastDescription;

static char activityStates[4] = "-\\|/";

+ (Activity *)activity {
    
    return [[self new] autorelease];
}

- (id)init {
    
    if (!(self = [super init]))
        return self;
    
    index = -1;
    
    return self;
}

- (char)activityStateWithDescription:(NSString *)description {
    
    if (![lastDescription isEqualToString:description]) {
        index = (index + 1) % (sizeof(activityStates) / sizeof(char));
        self.lastDescription = description;
    }

    return activityStates[index];
}

@end

@implementation CCNode (CCDebug)

- (void)draw_CCDebug {
    
    if (!drawOrder_CCDebug)
        drawOrder_CCDebug = [[NSMutableDictionary alloc] init];
    if ([self isKindOfClass:[CCScene class]])
        order_CCDebug = 0;

    [drawOrder_CCDebug setObject:[NSNumber numberWithUnsignedInt:order_CCDebug++] forKey:[NSValue valueWithPointer:self]];
    
    [self draw_CCDebug];
}

@end
