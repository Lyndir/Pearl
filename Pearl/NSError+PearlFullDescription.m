//
// Created by Maarten Billemont on 11/30/2013.
// Copyright (c) 2013 Lyndir. All rights reserved.
//


#import "NSError+PearlFullDescription.h"

@implementation NSError(PearlFullDescription)

- (NSString *)fullDescription {

    NSMutableString *fullDescription = [NSMutableString new];
    [fullDescription appendFormat:@"Error: %lu (%@): %@\n", (long)self.code, self.domain, self.localizedDescription];
    if (self.localizedRecoveryOptions)
        [fullDescription appendFormat:@" - RecoveryOptions: %@\n", self.localizedRecoveryOptions];
    if (self.localizedRecoverySuggestion)
        [fullDescription appendFormat:@" - RecoverySuggestion: %@\n", self.localizedRecoverySuggestion];
    if (self.localizedFailureReason)
        [fullDescription appendFormat:@" - FailureReason: %@\n", self.localizedFailureReason];
    if (self.helpAnchor)
        [fullDescription appendFormat:@" - HelpAnchor: %@\n", self.helpAnchor];
    if (self.userInfo) {
        for (id key in self.userInfo) {
            id info = self.userInfo[key];
            NSMutableString *infoString;
            @try {
                if ([info respondsToSelector:@selector( fullDescription )])
                    infoString = [[info fullDescription] mutableCopy];
                else if ([info respondsToSelector:@selector( debugDescription )])
                    infoString = [[info debugDescription] mutableCopy];
                else
                    infoString = [[info description] mutableCopy];
            }
            @catch (NSException *exception) {
                infoString = [NSMutableString stringWithFormat:@"%@: inaccessible: %@",
                                                               NSStringFromClass( [info class] ), [exception fullDescription]];
            }

            NSString *keyString = strf(@" - Info %@: [%@] ", key, [info class]);
            NSString *indentedNewline = [@"\n" stringByPaddingToLength:[keyString length] + 1
                                                            withString:@" " startingAtIndex:0];
            [infoString replaceOccurrencesOfString:@"\n" withString:indentedNewline options:0
                                             range:NSMakeRange( 0, [infoString length] )];
            [fullDescription appendString:keyString];
            [fullDescription appendString:infoString];
            [fullDescription appendString:@"\n"];
        }
    }

    return fullDescription;
}

@end

@implementation NSException(PearlFullDescription)

- (NSString *)fullDescription {

    NSMutableString *fullDescription = [NSMutableString new];
    [fullDescription appendFormat:@"Exception: %@: %@\n", self.name, self.reason];
    [fullDescription appendFormat:@" - Call Stack:\n"];
    for (NSUInteger s = 0; s < [self.callStackSymbols count]; ++s)
        [fullDescription appendFormat:@"     %lu. %@\n", (long)s, self.callStackSymbols[s]];
    if (self.userInfo) {
        for (id key in self.userInfo) {
            id info = self.userInfo[key];
            NSMutableString *infoString;
            @try {
                if ([info respondsToSelector:@selector( fullDescription )])
                    infoString = [[info fullDescription] mutableCopy];
                else if ([info respondsToSelector:@selector( debugDescription )])
                    infoString = [[info debugDescription] mutableCopy];
                else
                    infoString = [[info description] mutableCopy];
            }
            @catch (NSException *exception) {
                infoString = [NSMutableString stringWithFormat:@"%@: inaccessible: %@",
                                                               NSStringFromClass( [info class] ), [exception fullDescription]];
            }

            NSString *keyString = strf(@" - Info %@: [%@] ", key, [info class]);
            NSString *indentedNewline = [@"\n" stringByPaddingToLength:[keyString length] + 1
                                                            withString:@" " startingAtIndex:0];
            [infoString replaceOccurrencesOfString:@"\n" withString:indentedNewline options:0
                                             range:NSMakeRange( 0, [infoString length] )];
            [fullDescription appendString:keyString];
            [fullDescription appendString:infoString];
            [fullDescription appendString:@"\n"];
        }
    }

    return fullDescription;
}

@end

