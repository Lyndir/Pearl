//
// Created by Maarten Billemont on 11/30/2013.
// Copyright (c) 2013 Lyndir. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSError (PearlFullDescription)

- (NSString *)fullDescription;

@end

@interface NSException (PearlFullDescription)

- (NSString *)fullDescription;

@end
