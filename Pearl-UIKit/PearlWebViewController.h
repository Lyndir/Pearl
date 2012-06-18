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
//  PrivacyVC.h
//
//  Created by Maarten Billemont on 12/01/11.
//  Copyright 2010 Lhunath. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PearlWebViewController : UIViewController<UIWebViewDelegate> {

    UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
