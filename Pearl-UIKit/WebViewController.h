//
//  PrivacyVC.h
//
//  Created by Maarten Billemont on 12/01/11.
//  Copyright 2010 Lhunath. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {

    UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
