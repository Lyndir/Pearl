//
//  NSObject_Export.h
//  RedButton
//
//  Created by Maarten Billemont on 16/06/11.
//  Copyright 2011 Lin.K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_Export)

- (id)exportToCodable;

+ (id)exportToCodable:(id)object;

@end
