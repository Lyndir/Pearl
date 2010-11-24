//
//  ValidatingTextField.h
//  iLibs
//
//  Created by Maarten Billemont on 04/11/10.
//  Copyright, lhunath (Maarten Billemont) 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ValidatingTextField;

@protocol ValidatingTextFieldDelegate

- (BOOL)isValid:(ValidatingTextField *)textField;

@end

@interface ValidatingTextField : UITextField {

    BOOL                            (^_isValid)(void);
    UIView                          *_validView, *_invalidView;
    id<ValidatingTextFieldDelegate> _validationDelegate;
}

@property (nonatomic, assign) IBOutlet id<ValidatingTextFieldDelegate> validationDelegate;

@end
