//
//  PrivacyVC.h
//
//  Created by Maarten Billemont on 05/11/10.
//  Copyright 2010 Lhunath. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ArrayTVCRowStylePlain,              // A row that does nothing.
    ArrayTVCRowStyleLink,               // A row that can be tapped.
    ArrayTVCRowStyleDisclosure,         // A row that has a detail disclosure arrow.
    ArrayTVCRowStyleCheck,              // A row that the user can put a checkmark on.
    ArrayTVCRowStyleToggle,             // A row that has a toggle component.
} ArrayTVCRowStyle;

@protocol ArrayTVCDelegate

/**
 * Invoked on the delegate of a row when that row is activated (eg. by a user's tap).
 *
 * @param toggled The toggled state that the row will get if this method permits its activation.
 *
 * @return YES if the activation is permitted.  This will toggle the row's state if it is a check or toggle style.
 */
- (BOOL)shouldActivateRowNamed:(NSString *)aName inSection:(NSString *)section withContext:(id)context toggleTo:(BOOL)toggled;

@end

@interface ArrayTVC : UITableViewController {

    NSMutableArray                                          *_sections;
}

/**
 * Remove all rows and sections from the table.
 */
- (void)removeAllRows;

/**
 * Remove the first row from the table that has the given name as label in the given section.
 * @param aSection The name of the section in which to search.  May be nil, in which case all sections will be searched.
 */
- (void)removeRowWithName:(NSString *)aName fromSection:(NSString *)aSection;

/**
 * Remove the first row from the table that was created with the given context in the given section.
 * @param aSection The name of the section in which to search.  May be nil, in which case all sections will be searched.
 */
- (void)removeRowWithContext:(id)aContext fromSection:(NSString *)aSection;

/**
 * Add a row to the table with the given name as label in the given section.
 * When tapped, activateRowNamed:inSection:withContext: will be invoked on the given delegate.
 */
- (void)addRowWithName:(NSString *)aName style:(ArrayTVCRowStyle)aStyle toggled:(BOOL)isToggled toSection:(NSString *)aSection
          withDelegate:(id<ArrayTVCDelegate>)aDelegate context:(id)aContext;

@end
