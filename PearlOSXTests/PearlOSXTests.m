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
//  PearlOSXTests.m
//  PearlOSXTests
//
//  Created by Maarten Billemont on 02/04/12.
//  Copyright (c) 2012 Lyndir. All rights reserved.
//

#import "PearlOSXTests.h"

@implementation PearlOSXTests

- (void)setUp {

    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}
//
//- (void)testEndian {
//    
//#if __LITTLE_ENDIAN__
//    inf(@"OSX: little endian");
//#else
//    inf(@"OSX: big endian");
//#endif
//}
- (void)testSCrypt {

    uint64_t N;
    uint32_t r, p;

    PearlSCrypt *scrypt = [[PearlSCrypt alloc] initWithMemoryFraction:0 maximum:0 time:1];
    [scrypt determineParametersN:&N r:&r p:&p];

    inf(@"N: %llu, r: %u, p: %u", N, r, p);
    NSDate *start = [NSDate date];
    [scrypt deriveKeyWithLength:64
                   fromPassword:
                    [@"dkjhsdkhsadkjhsakhdaksjhdkjsahdkashkdjhaskdhsakjdhkasjhdklashdlkashdlksajhdkljashdkasjsdlhvbkdfhvsbliuawoidndUEBFLIUSDBNLUBDWDVHJABSJHjjdlhsh" dataUsingEncoding:NSUTF8StringEncoding]
                   usingSalt:
                    [@"dkjhsdkhsadkjhsakhdaksjhdkjsahdkashkdjhaskdhsakjdhkasjhdklashdlkashdlksajhdkljashdkasjsdlhvbkdfhvsbliuawoidndUEBFLIUSDBNLUBDWDVHJABSJHjjdlhsh" dataUsingEncoding:NSUTF8StringEncoding]];
    inf(@"done after %0.2fs", -[start timeIntervalSinceNow]);
    start = [NSDate date];
    [PearlSCrypt deriveKeyWithLength:64
                   fromPassword:
     [@"dkjhsdkhsadkjhsakhdaksjhdkjsahdkashkdjhaskdhsakjdhkasjhdklashdlkashdlksajhdkljashdkasjsdlhvbkdfhvsbliuawoidndUEBFLIUSDBNLUBDWDVHJABSJHjjdlhsh" dataUsingEncoding:NSUTF8StringEncoding]
                      usingSalt:
     [@"dkjhsdkhsadkjhsakhdaksjhdkjsahdkashkdjhaskdhsakjdhkasjhdklashdlkashdlksajhdkljashdkasjsdlhvbkdfhvsbliuawoidndUEBFLIUSDBNLUBDWDVHJABSJHjjdlhsh" dataUsingEncoding:NSUTF8StringEncoding] N:32768 r:8 p:2];
    inf(@"done after %0.2fs", -[start timeIntervalSinceNow]);
    for (int i = 0; i < 100; ++i)
        [PearlSCrypt deriveKeyWithLength:64
                            fromPassword:
         [@"dkjhsdkhsadkjhsakhdaksjhdkjsahdkashkdjhaskdhsakjdhkasjhdklashdlkashdlksajhdkljashdkasjsdlhvbkdfhvsbliuawoidndUEBFLIUSDBNLUBDWDVHJABSJHjjdlhsh" dataUsingEncoding:NSUTF8StringEncoding]
                               usingSalt:
         [@"dkjhsdkhsadkjhsakhdaksjhdkjsahdkashkdjhaskdhsakjdhkasjhdklashdlkashdlksajhdkljashdkasjsdlhvbkdfhvsbliuawoidndUEBFLIUSDBNLUBDWDVHJABSJHjjdlhsh" dataUsingEncoding:NSUTF8StringEncoding] N:32768 r:8 p:2];
    inf(@"100x done after %0.2fs", -[start timeIntervalSinceNow]);
}

//- (void)testKVC {
//
//    NSDictionary *testDict = [NSDictionary dictionaryWithObject:[NSOrderedSet orderedSetWithObjects:
//                                                                  [NSDictionary dictionaryWithObject:@"one" forKey:@"inner"],
//                                                                  [NSDictionary dictionaryWithObject:@"two" forKey:@"inner"],
//                                                                  nil]
//                                                         forKey:@"outer"];
//    id result = [testDict valueForKeyPath:@"outer.@distinctUnionOfSets.inner"];
//    inf(@"result: %@ %@", [result class], result);
//}

@end
