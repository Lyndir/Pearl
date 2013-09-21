/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */
//
//  PearlCCDebug.m
//  Deblock
//
//  Created by Maarten Billemont on 03/04/11.
//  Copyright 2011 Lhunath. All rights reserved.
//

#import "PearlCCDebug.h"
#import "PearlStringUtils.h"
#import "JRSwizzle.h"


static NSMutableDictionary *PearlCCDebugDrawOrder;

@interface PearlCCDebugActivity : NSObject {
@private
    long index;
    NSString *lastDescription;
}

@property (nonatomic, retain) NSString *lastDescription;

- (char)activityStateWithDescription:(NSString *)description;

@end

@interface CCNode (PearlCCDebug)

- (void)draw_PearlCCDebug;

@end

@implementation PearlCCDebug

+ (void)initialize {

    NSError *error = nil;
    [CCNode jr_swizzleMethod:@selector(draw) withMethod:@selector(draw_PearlCCDebug) error:&error];
    if (error)
    dbg(@"Swizzling error: %@", error);
}

+ (void)printStateForScene:(CCScene *)scene {

    [self printStateForNode:scene indent:0];
}

+ (void)printStateForNode:(CCNode *)node indent:(NSUInteger)indent {

    static NSMutableDictionary *nodeActivity;
    if (nodeActivity == nil)
        nodeActivity = [[NSMutableDictionary alloc] init];

    NSValue              *nodeValue = [NSValue valueWithPointer:(void *)node];
    PearlCCDebugActivity *activity  = [nodeActivity objectForKey:nodeValue];
    if (activity == nil)
        [nodeActivity setObject:activity = [PearlCCDebugActivity new] forKey:nodeValue];

    NSString *nodeDescription = [self describe:node];
    char activityState = [activity activityStateWithDescription:nodeDescription];

    NSNumber *drawOrder = [PearlCCDebugDrawOrder objectForKey:nodeValue];

    dbg(@"%*s%@. [%c] %@", (int)(4 * indent), "", drawOrder? [drawOrder description]: @"x", activityState, nodeDescription);
    for (CCNode *child in node.children)
        [self printStateForNode:child indent:indent + 1];
}

+ (NSString *)describe:(CCNode *)node {

    return [NSString stringWithFormat:@"z: %ld, %@", (long)node.zOrder, [node description]];
}

@end

@implementation PearlCCDebugActivity

@synthesize lastDescription;

- (id)init {

    if (!(self = [super init]))
        return self;

    index = -1;

    return self;
}

- (char)activityStateWithDescription:(NSString *)description {

    static char activityStates[4] = "-\\|/";
    if (![lastDescription isEqualToString:description]) {
        index = (index + 1) % (signed)(sizeof(activityStates) / sizeof(char));
        self.lastDescription = description;
    }

    return activityStates[index];
}

@end

@implementation CCNode (PearlCCDebug)

- (void)draw_PearlCCDebug {

    if (!PearlCCDebugDrawOrder)
        PearlCCDebugDrawOrder = [[NSMutableDictionary alloc] init];

    static NSUInteger order = 0;
    if ([self isKindOfClass:[CCScene class]])
        order = 0;

    [PearlCCDebugDrawOrder setObject:[NSNumber numberWithUnsignedInteger:order++] forKey:[NSValue valueWithPointer:(void *)self]];

    [self draw_PearlCCDebug];
}

@end
