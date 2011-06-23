//
//  ValidatingTextField.m
//  Pearl
//
//  Created by Maarten Billemont on 04/11/10.
//  Copyright, lhunath (Maarten Billemont) 2010. All rights reserved.
//

#import "ValidatingTextField.h"
#import "UIUtils.h"


@interface ValidatingTextField ()

- (void)textFieldDidChange;

@end


@implementation ValidatingTextField
@synthesize validationDelegate = _validationDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return self;

    _validView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accept.png"]];
    _invalidView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exclamation.png"]];
    self.rightViewMode = UITextFieldViewModeAlways;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    [self textFieldDidChange];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {

    if (!(self = [super initWithFrame:frame]))
        return self;
    
    _validView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accept.png"]];
    _invalidView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exclamation.png"]];
    
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    [self textFieldDidChange];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame validationBlock:(BOOL (^)(void))isValid {
    
    if (!(self = [self initWithFrame:frame]))
        return self;
    
    _isValid = isValid;
    
    return self;
}

- (void)textFieldDidChange {

    BOOL valid = YES;
    
    if (self.validationDelegate)
        valid &= [self.validationDelegate isValid:self];
    if (_isValid)
        valid &= _isValid();
    
    if (!self.validationDelegate && !_isValid)
        // No validators, default action is to check whether the field is non-empty.
        valid = self.text.length;
    
    self.rightView = valid? _validView: _invalidView;
}

@end
