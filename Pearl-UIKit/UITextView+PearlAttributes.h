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

#import <Foundation/Foundation.h>

@interface UITextField(PearlAttributes)

- (NSDictionary *)textAttributes;

@end

@interface UILabel(PearlAttributes)

- (NSDictionary *)textAttributes;

@end

@interface UITextView(PearlAttributes)

- (NSDictionary *)textAttributes;

@end
