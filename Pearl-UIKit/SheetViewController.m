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
//  SheetViewController.m
//  Pearl
//
//  Created by Maarten Billemont on 08/08/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import "PearlAppDelegate.h"
#import "SheetViewController.h"
#import "Layout.h"
#import "StringUtils.h"


@interface SheetViewController (Private)

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
         otherTitle:(NSString *)otherTitle :(va_list)otherTitlesList;
+ (SheetViewController *)showSheetWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
                          tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
                                 otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList;

@end


@implementation SheetViewController
@synthesize sheetView;

+ (NSMutableArray *)activeSheets {
    
    static NSMutableArray *activeSheets = nil;
    if (!activeSheets)
        activeSheets = [[NSMutableArray alloc] initWithCapacity:3];
    
    return activeSheets;
}


#pragma mark ###############################
#pragma mark Lifecycle

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle {
    
    return [self initWithTitle:title message:message viewStyle:UIActionSheetStyleAutomatic tappedButtonBlock:nil
                   cancelTitle:cancelTitle destructiveTitle:nil otherTitles:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
        otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self initWithTitle:title message:message viewStyle:viewStyle tappedButtonBlock:aTappedButtonBlock
                   cancelTitle:cancelTitle destructiveTitle:destructiveTitle
                    otherTitle:otherTitles :otherTitlesList];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
         otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {
    
    if (!(self = [super init]))
        return self;
    
    [self setTitle:title];
    
    tappedButtonBlock               = [aTappedButtonBlock copy];
    sheetView                       = [[UIActionSheet alloc] initWithTitle:title delegate:[self retain]
                                                         cancelButtonTitle:nil destructiveButtonTitle:nil
                                                         otherButtonTitles:firstOtherTitle, nil];
    sheetView.actionSheetStyle = viewStyle;
    
    if (firstOtherTitle && otherTitlesList) {
        for (NSString *otherTitle; (otherTitle = va_arg(otherTitlesList, id));)
            [sheetView addButtonWithTitle:otherTitle];
        va_end(otherTitlesList);
    }
    if (cancelTitle)
        sheetView.cancelButtonIndex = [sheetView addButtonWithTitle:cancelTitle];
    if (destructiveTitle)
        sheetView.destructiveButtonIndex = [sheetView addButtonWithTitle:destructiveTitle];
    
    return self;
}

+ (SheetViewController *)showError:(NSString *)message {
    
    return [self showSheetWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIActionSheetStyleAutomatic
                  tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonOkay destructiveTitle:nil otherTitles:nil];
}

+ (SheetViewController *)showError:(NSString *)message
                 tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                       destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSString *)otherTitles, ...  {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showSheetWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIActionSheetStyleAutomatic
                  tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonOkay destructiveTitle:destructiveTitle
                         otherTitle:otherTitles :otherTitlesList];
}

+ (SheetViewController *)showNotice:(NSString *)message {
    
    return [self showSheetWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIActionSheetStyleAutomatic
                  tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonThanks destructiveTitle:nil otherTitles:nil];
}

+ (SheetViewController *)showNotice:(NSString *)message
                  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                        destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showSheetWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIActionSheetStyleAutomatic
                  tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonThanks destructiveTitle:destructiveTitle
                         otherTitle:otherTitles :otherTitlesList];
}

+ (SheetViewController *)showSheetWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
                          tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
                                 otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {
    
    return [[[[SheetViewController alloc] initWithTitle:title message:message viewStyle:viewStyle
                                      tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle destructiveTitle:destructiveTitle
                                             otherTitle:firstOtherTitle :otherTitlesList] autorelease] showSheet];
}

+ (SheetViewController *)showSheetWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
                          tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
                                otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showSheetWithTitle:title message:message viewStyle:viewStyle tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:cancelTitle destructiveTitle:destructiveTitle
                         otherTitle:otherTitles :otherTitlesList];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    
    [sheetView release];
    sheetView = nil;
    
    [tappedButtonBlock release];
    tappedButtonBlock = nil;
    
    [super dealloc];
}


#pragma mark ###############################
#pragma mark Behaviors

- (SheetViewController *)showSheet {
    
    [sheetView showInView:[UIApplication sharedApplication].keyWindow];
    [((NSMutableArray *) [SheetViewController activeSheets]) addObject:self];
    
    return self;
}


- (SheetViewController *)dismissSheet {
    
    [sheetView dismissWithClickedButtonIndex:0 animated:YES];
    
    return self;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (tappedButtonBlock)
        tappedButtonBlock(self.sheetView, buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [((NSMutableArray *) [SheetViewController activeSheets]) removeObject:self];
    
    [tappedButtonBlock release];
    tappedButtonBlock = nil;
}


@end
