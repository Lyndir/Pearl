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

    static PearlStrings *pearlStrings = nil;
    if (pearlStrings == nil)
        pearlStrings = [PearlStrings new];

    return pearlStrings;
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

@end
