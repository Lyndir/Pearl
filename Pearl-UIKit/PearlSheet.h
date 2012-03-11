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
@interface PearlSheet : NSObject <UIActionSheetDelegate> {

@private
    UIActionSheet           *sheetView;
    
    void (^tappedButtonBlock)(UIActionSheet *sheet, NSInteger buttonIndex);
}

@property (nonatomic, retain) UIActionSheet *sheetView;


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
 * @param message           The message string to display in the view.
 * @param viewStyle         The type of sheet to show.
 * @param tappedButtonBlock A block that gets invoked when the user taps a button of the sheet.  The tapped sheet view is given along with the index of the button that was tapped.
 * @param cancelTitle       The text on the cancel button or nil to not show this button.
 * @param otherTitles       The text on action buttons or nil to not show any such buttons.
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
        cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (PearlSheet *)showError:(NSString *)message;
+ (PearlSheet *)showError:(NSString *)message
                 tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                       destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (PearlSheet *)showNotice:(NSString *)message;
+ (PearlSheet *)showNotice:(NSString *)message
                  tappedButtonBlock:(void (^)(UIActionSheet *sheet, NSInteger buttonIndex))aTappedButtonBlock
                        destructiveTitle:(NSString *)destructiveTitle otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Initializes and shows a sheet.  See -initWithTitle:message:viewStyle:tappedButtonBlock:cancelTitle:otherTitles:
 */
+ (PearlSheet *)showSheetWithTitle:(NSString *)title message:(NSString *)message viewStyle:(UIActionSheetStyle)viewStyle
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
 * Dismiss the sheet managed by this controller.
 *
 * @return  self, for chaining.
 */
- (PearlSheet *)dismissSheet;

@end
