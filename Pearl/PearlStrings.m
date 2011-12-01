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
@dynamic commonButtonAbort;
@dynamic commonButtonUpgrade;
@dynamic commonButtonYes;
@dynamic commonButtonNo;
@dynamic commonButtonNoKind;
@dynamic commonButtonSave;
@dynamic commonButtonSure;
@dynamic commonButtonThanks;
@dynamic crashTitle;
@dynamic crashContent;

@end
