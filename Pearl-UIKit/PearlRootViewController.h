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
//  PearlRootViewController.h
//  Gorillas
//
//  Created by Maarten Billemont on 12/11/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PearlRootViewController : UIViewController

- (id)initWithView:(UIView *)aView;

- (BOOL)isInterfaceOrientationSupported:(UIInterfaceOrientation)interfaceOrientation;
- (void)supportInterfaceOrientationString:(NSString *)interfaceOrientation;
- (void)supportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)rejectInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
