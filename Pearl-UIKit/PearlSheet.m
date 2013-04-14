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
//  PearlSheet.m
//  Pearl
//
//  Created by Maarten Billemont on 08/08/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import "PearlSheet.h"

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

- (id)initWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle {

    return [self initWithTitle:title viewStyle:UIActionSheetStyleAutomatic initSheet:nil tappedButtonBlock:nil
                   cancelTitle:cancelTitle
              destructiveTitle:nil otherTitles:nil];
}

- (id)initWithTitle:(NSString *)title viewStyle:(UIActionSheetStyle)viewStyle
          initSheet:(void (^)(UIActionSheet *sheet))initBlock
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
        otherTitles:(NSString *)otherTitles, ... {

    va_list otherTitlesList;
    va_start(otherTitlesList, otherTitles);

    return [self initWithTitle:title viewStyle:viewStyle initSheet:initBlock tappedButtonBlock:aTappedButtonBlock
                   cancelTitle:cancelTitle destructiveTitle:destructiveTitle
                    otherTitle:otherTitles :otherTitlesList];
}

- (id)initWithTitle:(NSString *)title viewStyle:(UIActionSheetStyle)viewStyle
          initSheet:(void (^)(UIActionSheet *sheet))initBlock
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
         otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {

    if (!(self = [super init]))
        return self;

    NSAssert([NSThread currentThread].isMainThread, @"Should be on the main thread; was on thread: %@", [NSThread currentThread].name);

    tappedButtonBlock = [aTappedButtonBlock copy];
    sheetView         = [[UIActionSheet alloc] initWithTitle:title delegate:self
                                           cancelButtonTitle:nil destructiveButtonTitle:destructiveTitle otherButtonTitles:firstOtherTitle,
                                                                                                                           nil];
    sheetView.actionSheetStyle = viewStyle;

    if (firstOtherTitle) {
        for (NSString *otherTitle; (otherTitle = va_arg(otherTitlesList, id));)
            [sheetView addButtonWithTitle:otherTitle];
        va_end(otherTitlesList);
    }
    if (initBlock)
        initBlock(sheetView);
    if (cancelTitle)
        sheetView.cancelButtonIndex = [sheetView addButtonWithTitle:cancelTitle];

    return self;
}

+ (instancetype)showSheetWithTitle:(NSString *)title viewStyle:(UIActionSheetStyle)viewStyle
                         initSheet:(void (^)(UIActionSheet *sheet))initBlock
                 tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                       cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
                        otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {

    return [[[self alloc] initWithTitle:title viewStyle:viewStyle
                              initSheet:initBlock
                      tappedButtonBlock:aTappedButtonBlock cancelTitle:cancelTitle destructiveTitle:destructiveTitle
                             otherTitle:firstOtherTitle :otherTitlesList] showSheet];
}

+ (instancetype)showSheetWithTitle:(NSString *)title viewStyle:(UIActionSheetStyle)viewStyle
                         initSheet:(void (^)(UIActionSheet *sheet))initBlock
                 tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                       cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
                       otherTitles:(NSString *)otherTitles, ... {

    va_list otherTitlesList;
    va_start(otherTitlesList, otherTitles);

    return [self showSheetWithTitle:title viewStyle:viewStyle initSheet:initBlock tappedButtonBlock:aTappedButtonBlock
                        cancelTitle:cancelTitle destructiveTitle:destructiveTitle
                         otherTitle:otherTitles :otherTitlesList];
}

#pragma mark ###############################
#pragma mark Behaviors

- (PearlSheet *)showSheet {

    PearlMainThread(^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window)
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIView *view = window.rootViewController.view;
        if (!view)
            view = window;
        [sheetView showInView:view];
        [((NSMutableArray *)[PearlSheet activeSheets]) addObject:self];
    });

    return self;
}

- (BOOL)isVisible {

    return [sheetView isVisible];
}

- (PearlSheet *)dismissSheet {

    PearlMainThread(^{
        [sheetView dismissWithClickedButtonIndex:0 animated:YES];
    });

    return self;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (tappedButtonBlock)
        tappedButtonBlock(self.sheetView, buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    [((NSMutableArray *)[PearlSheet activeSheets]) removeObject:self];
}


@end
