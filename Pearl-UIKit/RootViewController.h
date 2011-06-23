//
//  RootViewController.h
//  Gorillas
//
//  Created by Maarten Billemont on 12/11/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController {

    NSMutableArray                              *_supportedIterfaceOrientations;
}

@property (nonatomic, retain) NSMutableArray    *supportedIterfaceOrientations;

- (id)initWithView:(UIView *)aView;

- (BOOL)isInterfaceOrientationSupported:(UIInterfaceOrientation)interfaceOrientation;
- (void)supportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)rejectInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
