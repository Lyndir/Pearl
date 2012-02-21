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
        valid = self.text.length > 0;
    
    self.rightView = valid? _validView: _invalidView;
}

@end
