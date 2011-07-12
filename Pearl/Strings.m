//
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import "Strings.h"


@implementation Strings

@synthesize tableName = _tableName;

- (id)initWithTable:(NSString *)tableName {

    if (!( self = [super init] ))
        return nil;

    self.tableName = tableName;

    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {

    static NSBundle *mainBundle = nil;
    if (!mainBundle)
        mainBundle = [NSBundle mainBundle];
    static NSRegularExpression *selectorToKey = nil;
    if (!selectorToKey)
        selectorToKey = [[NSRegularExpression alloc] initWithPattern:@"([a-z])([A-Z])" options:0 error:nil];

    NSString *selector = NSStringFromSelector(anInvocation.selector);
    NSString *key      = [[selectorToKey
            stringByReplacingMatchesInString:selector options:0 range:NSMakeRange(0, [selector length]) withTemplate:@"$1.$2"]
            lowercaseString];
    id value = [mainBundle localizedStringForKey:key
                                           value:[mainBundle localizedStringForKey:key value:nil table:self.tableName]
                                           table:nil];
    [anInvocation setReturnValue:&value];
}

- (void)dealloc {

    self.tableName = nil;

    [super dealloc];
}

@end
