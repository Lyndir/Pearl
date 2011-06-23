//
//  SheetViewController.h
//  Pearl
//
//  Created by Maarten Billemont on 08/08/09.
//  Copyright, lhunath (Maarten Billemont) 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * The sheet view controller manages a view that displays a short message to the user.
 *
 * The user is presented with a message in small font at the bottom of the screen.
 */
@interface SheetViewController : UIViewController <UIActionSheetDelegate> {

@private
    UIActionSheet           *sheetView;
    
    NSInvocation            *invocation;
}


#pragma mark ###############################
#pragma mark Lifecycle

/**
 * Create a sheet view controller which conveys the specified information.
 *
 * @param title     The title to put in the navigation bar.
 */
- (id)initWithTitle:(NSString *)title;

/**
 * Create a sheet view controller which conveys the specified information.
 * The cancel/back button causes this view controller to get dismissed (returning to the previous state).
 *
 * @param title         The title of the sheet.
 * @param backString    The text on the cancel/back button or nil to not show such a button.
 */
- (id)initWithTitle:(NSString *)aTitle backString:(NSString *)backString;

/**
 * Create a sheet view controller which conveys the specified information.
 * The cancel/back button causes this view controller to get dismissed (returning to the previous state).
 * The ok/accept button can be used for custom action.
 *
 * @param title         The title of the sheet.
 * @param backString    The text on the cancel/back button or nil to not show such a button.
 * @param acceptString  The text on the ok/accept button or nil to not show such a button.
 * @param callback      The target and selector to invoke when the accept button gets tapped.
 */
- (id)initWithTitle:(NSString *)aTitle
         backString:(NSString *)backString acceptString:(NSString *)acceptString
           callback:(id)target :(SEL)selector;

/**
 * Create a sheet view controller which shows a given message.
 */
+ (SheetViewController *)showMessage:(NSString *)message;
/**
 * Create a sheet view controller which shows a given message which allows you to hide the back button.
 */
+ (SheetViewController *)showMessage:(NSString *)message backButton:(BOOL)backButton;
/**
 * Create a sheet view controller which shows a given message
 * and allows you to specify the text to use on the back and accept buttons.
 *
 * Use nil for either to hide it.
 */
+ (SheetViewController *)showMessage:(NSString *)message
                          backString:(NSString *)backString acceptString:(NSString *)acceptString;


#pragma mark ###############################
#pragma mark Behaviors

/**
 * Show the sheet managed by this view controller.
 *
 * @return  self, for chaining.
 */
- (SheetViewController *)showSheet;

/**
 * Dismiss the sheet managed by this controller.
 *
 * @return  self, for chaining.
 */
- (SheetViewController *)dismissSheet;

/**
 * Change the callback to invoke when the sheet's back/accept button is tapped.
 *
 * @param target        The target object upon which the callback selector will be invoked.
 * @param selector      The callback selector to invoke on the target object as soon as the back/accept button is tapped.
 *                      The selector should take (at least) one argument (NSNumber*).
 *                      That argument will be set to the index of the button that was used to dismiss the alert (base 1).
 */
- (void)setTarget:(id)t selector:(SEL)s;

@end
