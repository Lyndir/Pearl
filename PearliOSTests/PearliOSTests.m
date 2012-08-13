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

//- (void)testSCrypt {
//
//    uint64_t N;
//    uint32_t r, p;
//
//    PearlSCrypt *scrypt = [[PearlSCrypt alloc] initWithMemoryFraction:0.3f maximum:0 time:3];
//    [scrypt determineParametersN:&N r:&r p:&p];
//
//    inf(@"N: %u, r: %u, p: %u", N, r, p);
//    [scrypt deriveKeyWithLength:64
//                   fromPassword:
//                    [@"dkjhsdkhsadkjhsakhdaksjhdkjsahdkashkdjhaskdhsakjdhkasjhdklashdlkashdlksajhdkljashdkasjsdlhvbkdfhvsbliuawoidndUEBFLIUSDBNLUBDWDVHJABSJHjjdlhsh" dataUsingEncoding:NSUTF8StringEncoding]
//                   usingSalt:
//                    [@"dkjhsdkhsadkjhsakhdaksjhdkjsahdkashkdjhaskdhsakjdhkasjhdklashdlkashdlksajhdkljashdkasjsdlhvbkdfhvsbliuawoidndUEBFLIUSDBNLUBDWDVHJABSJHjjdlhsh" dataUsingEncoding:NSUTF8StringEncoding]];
//    inf(@"done");
//}

@end
