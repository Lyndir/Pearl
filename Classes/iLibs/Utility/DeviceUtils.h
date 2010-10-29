//
//  DeviceUtils.h
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>


/** YES when invoked on an iPod touch device. */
BOOL IsIPod(void);
/** YES when invoked on an iPhone device. */
BOOL IsIPhone(void);
/** YES when invoked on the iPhone simulator. */
BOOL IsSimulator(void);
