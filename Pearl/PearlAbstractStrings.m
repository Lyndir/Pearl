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
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


@implementation PearlAbstractStrings

- (id)initWithTable:(NSString *)tableName {

    if (!(self = [super init]))
        return nil;

    self.tableName = tableName;

    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {

    static NSRegularExpression *newWord = nil, *endAcronym = nil;
    if (!newWord)
        newWord = [[NSRegularExpression alloc] initWithPattern:@"(\\p{Ll})(?=\\p{Lu})" options:0 error:nil];
    if (!endAcronym)
        endAcronym = [[NSRegularExpression alloc] initWithPattern:@"(\\p{Lu}\\p{Lu})(?=\\p{Lu}\\p{Ll})" options:0 error:nil];

    NSString *selector = NSStringFromSelector( anInvocation.selector );
    NSString *key = [newWord stringByReplacingMatchesInString:selector options:0 range:NSMakeRange( 0, [selector length] )
                                                 withTemplate:@"$1."];
    key = [endAcronym stringByReplacingMatchesInString:key options:0 range:NSMakeRange( 0, [key length] )
                                          withTemplate:@"$1."];
    key = [key lowercaseString];
    id tableValue = [[NSBundle mainBundle] localizedStringForKey:key value:nil table:self.tableName];
    id value = [[NSBundle mainBundle] localizedStringForKey:key value:tableValue table:nil];

    __autoreleasing id returnValue = value;
    [anInvocation setReturnValue:&returnValue];
}

@end
