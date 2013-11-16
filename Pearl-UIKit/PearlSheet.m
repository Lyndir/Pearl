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
#import "PearlUIUtils.h"

@interface PearlSheet()

@property(nonatomic) BOOL handlingClick;
@end

@implementation PearlSheet

+ (NSMutableArray *)activeSheets {

    static NSMutableArray *activeSheets = nil;
    if (!activeSheets)
        activeSheets = [[NSMutableArray alloc] initWithCapacity:3];

    return activeSheets;
}


#pragma mark ###############################
#pragma mark Lifecycle

- (id)initWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle {

    return [self initWithTitle:title viewStyle:UIActionSheetStyleAutomatic initSheet:nil tappedButtonBlock:nil cancelTitle:cancelTitle
              destructiveTitle:nil otherTitles:nil];
}

- (id)initWithTitle:(NSString *)title viewStyle:(UIActionSheetStyle)viewStyle
          initSheet:(void (^)(UIActionSheet *sheet))initBlock
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))tappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
        otherTitles:(NSString *)otherTitles, ... {

    va_list otherTitlesList;
    va_start(otherTitlesList, otherTitles);

    return [self initWithTitle:title viewStyle:viewStyle initSheet:initBlock tappedButtonBlock:tappedButtonBlock
                   cancelTitle:cancelTitle destructiveTitle:destructiveTitle
                    otherTitle:otherTitles :otherTitlesList];
}

- (id)initWithTitle:(NSString *)title viewStyle:(UIActionSheetStyle)viewStyle
          initSheet:(void (^)(UIActionSheet *sheet))initBlock
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))tappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
         otherTitle:(NSString *)firstOtherTitle :(va_list)otherTitlesList {

    if (!(self = [super init]))
        return self;

    _tappedButtonBlock = [tappedButtonBlock copy];
    _sheetView = [[UIActionSheet alloc] initWithTitle:title delegate:self
                                    cancelButtonTitle:nil destructiveButtonTitle:destructiveTitle otherButtonTitles:firstOtherTitle,
                                                                                                                    nil];
    _sheetView.actionSheetStyle = viewStyle;

    if (firstOtherTitle) {
        for (NSString *otherTitle; (otherTitle = va_arg(otherTitlesList, id));)
            [_sheetView addButtonWithTitle:otherTitle];
        va_end(otherTitlesList);
    }

    PearlMainThreadStart {
        if (initBlock)
            initBlock( _sheetView );
        if (cancelTitle)
            _sheetView.cancelButtonIndex = [_sheetView addButtonWithTitle:cancelTitle];
    } PearlMainThreadEnd

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

    __weak UIActionSheet *sheetView = self.sheetView;
    PearlMainThread(^{
        if (!sheetView)
            return;

        UIWindow *window = UIApp.keyWindow;
        if (!window)
            window = [UIApp.windows objectAtIndex:0];
        UIView *view = window.rootViewController.view;
        if (!view)
            view = window;
        [sheetView showInView:view];
        [((NSMutableArray *)[PearlSheet activeSheets]) addObject:self];
    });

    return self;
}

- (BOOL)isVisible {

    return [self.sheetView isVisible];
}

- (PearlSheet *)cancelSheetAnimated:(BOOL)animated {

    __weak PearlSheet *wSelf = self;
    __weak UIActionSheet *sheet = self.sheetView;
    PearlMainThread(^{
        if (wSelf && !wSelf.handlingClick)
            [sheet dismissWithClickedButtonIndex:[sheet cancelButtonIndex] animated:animated];
    });

    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (self.tappedButtonBlock) {
        self.handlingClick = YES;
        self.tappedButtonBlock( self.sheetView, buttonIndex );
        self.handlingClick = NO;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    [((NSMutableArray *)[PearlSheet activeSheets]) removeObject:self];
}

@end
