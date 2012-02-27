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
//  PearlSheet.m
//  Pearl
//
//  Created by Maarten Billemont on 08/08/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import "PearlAppDelegate.h"
#import "PearlSheet.h"
#import "PearlLayout.h"
#import "PearlStringUtils.h"


@interface PearlSheet (Private)

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
         otherTitle:(NSString *)otherTitle :(va_list)otherTitlesList;
+ (PearlSheet *)showSheetWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
                          tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
                                 otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList;

@end


@implementation PearlSheet
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

+ (PearlSheet *)showError:(NSString *)message {
    
    return [self showSheetWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIActionSheetStyleAutomatic
                  tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonOkay destructiveTitle:nil otherTitles:nil];
}

+ (PearlSheet *)showError:(NSString *)message
                 tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                       destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSString *)otherTitles, ...  {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showSheetWithTitle:[PearlStrings get].commonTitleError message:message viewStyle:UIActionSheetStyleAutomatic
                  tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonOkay destructiveTitle:destructiveTitle
                         otherTitle:otherTitles :otherTitlesList];
}

+ (PearlSheet *)showNotice:(NSString *)message {
    
    return [self showSheetWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIActionSheetStyleAutomatic
                  tappedButtonBlock:nil
                        cancelTitle:[PearlStrings get].commonButtonThanks destructiveTitle:nil otherTitles:nil];
}

+ (PearlSheet *)showNotice:(NSString *)message
                  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                        destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSString *)otherTitles, ... {
    
    va_list(otherTitlesList);
    va_start(otherTitlesList, otherTitles);
    
    return [self showSheetWithTitle:[PearlStrings get].commonTitleNotice message:message viewStyle:UIActionSheetStyleAutomatic
                  tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:[PearlStrings get].commonButtonThanks destructiveTitle:destructiveTitle
                         otherTitle:otherTitles :otherTitlesList];
}

+ (PearlSheet *)showSheetWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
                          tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                                cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
                                 otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {
    
    return [[[[PearlSheet alloc] initWithTitle:title message:message viewStyle:viewStyle
                                      tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle destructiveTitle:destructiveTitle
                                             otherTitle:firstOtherTitle :otherTitlesList] autorelease] showSheet];
}

+ (PearlSheet *)showSheetWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
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

- (PearlSheet *)showSheet {
    
    [sheetView showInView:[UIApplication sharedApplication].keyWindow];
    [((NSMutableArray *) [PearlSheet activeSheets]) addObject:self];
    
    return self;
}


- (PearlSheet *)dismissSheet {
    
    [sheetView dismissWithClickedButtonIndex:0 animated:YES];
    
    return self;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (tappedButtonBlock)
        tappedButtonBlock(self.sheetView, buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [((NSMutableArray *) [PearlSheet activeSheets]) removeObject:self];
    
    [tappedButtonBlock release];
    tappedButtonBlock = nil;
}


@end
