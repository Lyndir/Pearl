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
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import "PearlStrings.h"


@implementation PearlStrings

- (id)init {

    return [super initWithTable:@"Pearl"];
}

+ (PearlStrings *)get {

    static PearlStrings *instance = nil;
    if (!instance)
        instance = [self new];

    return instance;
}

@dynamic timeDaySuffix;
@dynamic timeDaySuffixOne;
@dynamic timeDaySuffixTwo;
@dynamic timeDaySuffixThree;
@dynamic fontSizeSmall;
@dynamic fontSizeNormal;
@dynamic fontSizeLarge;
@dynamic fontFamilyDefault;
@dynamic fontFamilyFixed;
@dynamic fontFamilySymbolic;
@dynamic songSequential;
@dynamic songRandom;
@dynamic songOff;
@dynamic commonTitleNotice;
@dynamic commonTitleError;
@dynamic commonButtonOkay;
@dynamic commonButtonNext;
@dynamic commonButtonDone;
@dynamic commonButtonBack;
@dynamic commonButtonRetry;
@dynamic commonButtonCancel;
@dynamic commonButtonContinue;
@dynamic commonButtonAbort;
@dynamic commonButtonUpgrade;
@dynamic commonButtonYes;
@dynamic commonButtonNo;
@dynamic commonButtonNoKind;
@dynamic commonButtonSave;
@dynamic commonButtonSure;
@dynamic commonButtonThanks;
@dynamic reviewTitle;
@dynamic reviewMessage;
@dynamic reviewLater;
@dynamic reviewNow;
@dynamic reviewNever;

@end
