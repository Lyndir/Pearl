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
//  PearlTests.m
//  PearlTests
//
//  Created by Maarten Billemont on 21/02/12.
//  Copyright (c) 2012 Lyndir. All rights reserved.
//

#import "PearlTests.h"

@implementation PearlTests

- (void)setUp {

    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

- (void)testKeys {

    [PearlKeyChain generateKeyPairWithTag:@"Test"];
}

@end
