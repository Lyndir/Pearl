/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

#import "NSOrderedSetOrArray.h"

@implementation NSArray (NSOrderedSetOrArray)

- (NSSet *)set {

    return [NSSet setWithArray:self];
}

- (NSOrderedSet *)orderedSet {

    return [NSOrderedSet orderedSetWithArray:self];
}

- (NSArray *)array {

    return self;
}

@end

@implementation NSOrderedSet (NSOrderedSetOrArray)

- (NSOrderedSet *)orderedSet {

    return self;
}

@end
