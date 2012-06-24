//
//  PearlLazy.h
//  MasterPassword-iOS
//
//  Created by Maarten Billemont on 27/05/12.
//  Copyright (c) 2012 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PearlLazy : NSObject

+ (id)lazyObjectLoadedFrom:(id(^)(void))loadObject;
+ (id)lazyObjectLoadedFrom:(id(^)(void))loadObject trace:(BOOL)trace;

@end
