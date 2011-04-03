//
//  CCDebug.h
//  Deblock
//
//  Created by Maarten Billemont on 03/04/11.
//  Copyright 2011 Lhunath. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCDebug : NSObject {
    
}

+ (void)printStateForScene:(CCScene *)scene;
+ (void)printStateForNode:(CCNode *)node indent:(NSUInteger)indent;
+ (NSString *)describe:(CCNode *)node;

@end
