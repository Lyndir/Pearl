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
//  PearliOSTests.m
//  PearliOSTests
//
//  Created by Maarten Billemont on 01/04/12.
//  Copyright (c) 2012 Lyndir. All rights reserved.
//

#import "PearliOSTests.h"

@implementation PearliOSTests

- (void)setUp {

    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

- (void)testEndian {
    
#if __LITTLE_ENDIAN__
    inf(@"iOS: little endian");
#else
    inf(@"iOS: big endian");
#endif
}

@end
