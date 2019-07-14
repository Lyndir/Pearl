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
//  PearlValidatingTextField.h
//  Pearl
//
//  Created by Maarten Billemont on 04/11/10.
//  Copyright, lhunath (Maarten Billemont) 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PearlValidatingTextField;

@protocol PearlValidatingTextFieldDelegate

- (BOOL)checkValid:(PearlValidatingTextField *)textField;

@end

@interface PearlValidatingTextField : UITextField

@property(nonatomic, WEAK_OR_UNRETAINED) IBOutlet id<PearlValidatingTextFieldDelegate> validationDelegate;

@end
