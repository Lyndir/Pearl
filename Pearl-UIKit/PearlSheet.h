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
//  PearlSheet.h
//  Pearl
//
//  Created by Maarten Billemont on 08/08/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * The sheet view controller manages a view that displays a short message and choices to the user.
 *
 * The user is presented with a message in small font at the bottom of the screen along with some buttons that let him choose an action.
 */
@interface PearlSheet : NSObject<UIActionSheetDelegate>

@property(nonatomic, copy) void (^tappedButtonBlock)(UIActionSheet *sheet, NSInteger buttonIndex);
@property(nonatomic, strong) UIActionSheet *sheetView;


#pragma mark ###############################
#pragma mark Lifecycle

/**
 * A list of all sheets in order of appearance.  The last object is the one currently showing.
 */
+ (NSArray *)activeSheets;
/**
 * Create a sheet view controller that conveys the specified information and presents the specified actions.
 *
 * @param title             The title of the sheet.
 * @param viewStyle         The type of sheet to show.
 * @param tappedButtonBlock A block that gets invoked when the user taps a button of the sheet.  The tapped sheet view is given along with the index of the button that was tapped.
 * @param cancelTitle       The text on the cancel button or nil to not show this button.
 * @param otherTitles       The text on action buttons or nil to not show any such buttons.
 */
- (id)initWithTitle:(NSString *)title viewStyle:(UIActionSheetStyle)viewStyle
          initSheet:(void (^)(UIActionSheet *sheet))initBlock
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))tappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
        otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Initializes and shows a sheet.  See -initWithTitle:viewStyle:tappedButtonBlock:cancelTitle:otherTitles:
 */
+ (instancetype)showSheetWithTitle:(NSString *)title viewStyle:(UIActionSheetStyle)viewStyle
                         initSheet:(void (^)(UIActionSheet *sheet))initBlock
                 tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                       cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle
                       otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;


#pragma mark ###############################
#pragma mark Behaviors

/**
 * Show the sheet managed by this view controller.
 *
 * @return  self, for chaining.
 */
- (PearlSheet *)showSheet;

/**
 * @return YES if the sheet is currently visible.
 */
- (BOOL)isVisible;

/**
 * Dismiss the sheet managed by this controller.
 *
 * @return  self, for chaining.
 */
- (PearlSheet *)cancelSheetAnimated:(BOOL)animated;

@end
