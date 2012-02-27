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
//  PrivacyVC.m
//
//  Created by Maarten Billemont on 05/11/10.
//  Copyright 2010 Lhunath. All rights reserved.
//

#import "PearlWebViewController.h"


@interface PearlWebViewController ()

- (void)updateWebOrientation;

@end


@implementation PearlWebViewController
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
