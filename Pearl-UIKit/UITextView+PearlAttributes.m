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
//  UITextView(PearlAttributes).h
//  UITextView(PearlAttributes)
//
//  Created by lhunath on 2014-05-09.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import "UITextView+PearlAttributes.h"


@implementation UITextField(PearlAttributes)

- (NSDictionary *)textAttributes {

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.alignment = self.textAlignment;

    return @{
            NSFontAttributeName            : self.font,
            NSForegroundColorAttributeName : self.textColor,
            NSParagraphStyleAttributeName  : paragraph,
    };
}

@end

@implementation UILabel(PearlAttributes)

- (NSDictionary *)textAttributes {

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.alignment = self.textAlignment;

    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = self.shadowColor;
    shadow.shadowOffset = self.shadowOffset;

    return @{
            NSFontAttributeName            : self.font,
            NSForegroundColorAttributeName : self.textColor,
            NSParagraphStyleAttributeName  : paragraph,
            NSShadowAttributeName          : shadow,
    };
}

@end

@implementation UITextView(PearlAttributes)

- (NSDictionary *)textAttributes {

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.alignment = self.textAlignment;

    return @{
            NSFontAttributeName            : self.font,
            NSForegroundColorAttributeName : self.textColor,
            NSParagraphStyleAttributeName  : paragraph,
    };
}

@end
