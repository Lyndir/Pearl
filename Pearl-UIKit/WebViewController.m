//
//  PrivacyVC.m
//
//  Created by Maarten Billemont on 05/11/10.
//  Copyright 2010 Lhunath. All rights reserved.
//

#import "WebViewController.h"


@interface WebViewController ()

- (void)updateWebOrientation;

@end


@implementation WebViewController
@synthesize webView;

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self updateWebOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self updateWebOrientation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self updateWebOrientation];
}

- (void)updateWebOrientation {
    
    switch (self.interfaceOrientation) {
        case UIDeviceOrientationPortrait:
            [self.webView stringByEvaluatingJavaScriptFromString:
             @"window.__defineGetter__('orientation',function(){return 0;});window.onorientationchange();"];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            [self.webView stringByEvaluatingJavaScriptFromString:
             @"window.__defineGetter__('orientation',function(){return -90;});window.onorientationchange();"];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            [self.webView stringByEvaluatingJavaScriptFromString:
             @"window.__defineGetter__('orientation',function(){return 90;});window.onorientationchange();"];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            [self.webView stringByEvaluatingJavaScriptFromString:
             @"window.__defineGetter__('orientation',function(){return 180;});window.onorientationchange();"];
            break;
    }
}

@end
