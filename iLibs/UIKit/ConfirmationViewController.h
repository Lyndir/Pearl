//
//  ConfirmationViewController.h
//  iLibs
//
//  Created by Maarten Billemont on 22/12/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * The confirmation view controller manages a view that displays a message to the user.
 *
 * The user is presented with a message in large font type and an application-configurable button.
 * Optionally, a back button can be shown in the navigation controller that manages this view controller.
 */
@interface ConfirmationViewController : UIViewController {
    
@private
    UIImage         *logo;
    UIBarButtonItem *button;
    NSString        *message;
    
    BOOL            allowBack;
}


#pragma mark ###############################
#pragma mark Lifecycle

/**
 * Create a confirmation view controller which conveys the specified information.
 *
 * @param title     The title to put in the navigation bar.
 * @param logo      The image to use as a logo.  Use nil to show the default branding logo.
 * @param button    The UIBarButtonItem to put in the navigation bar.
                    If nil, a default button is used that says "Done" and pops back to the root view controller.
 * @param back      Whether to show a back button.
 * @param message   The message string to display in the view.
 */
- (id)initWithTitle:(NSString *)title logo:(UIImage *)logo button:(UIBarButtonItem *)b back:(BOOL)back message:(NSString *)msg;

#pragma mark ###############################
#pragma mark Behaviors

/** Set the callback to invoke when this view's navigation bar button is pressed. */
-(void)setButtonCallback:(id)target :(SEL)selector;

@end
