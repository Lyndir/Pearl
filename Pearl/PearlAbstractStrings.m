/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

//
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import "PearlAbstractStrings.h"


@implementation PearlAbstractStrings

@synthesize tableName = _tableName;

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
    
    NSString *selector  = NSStringFromSelector(anInvocation.selector);
    NSString *key       = [newWord stringByReplacingMatchesInString:selector options:0 range:NSMakeRange(0, [selector length])
                                                       withTemplate:@"$1."];
    key                 = [endAcronym stringByReplacingMatchesInString:key options:0 range:NSMakeRange(0, [key length])
                                                          withTemplate:@"$1."];
    key                 = [key lowercaseString];
    id tableValue       = [[NSBundle mainBundle] localizedStringForKey:key value:nil table:self.tableName];
    id value            = [[NSBundle mainBundle] localizedStringForKey:key value:tableValue table:nil];
    
    [anInvocation setReturnValue:&value];
}

- (void)dealloc {
    
    self.tableName = nil;
    
    [super dealloc];
}

@end
