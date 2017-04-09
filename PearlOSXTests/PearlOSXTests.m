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
