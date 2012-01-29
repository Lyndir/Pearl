//
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import <Foundation/Foundation.h>
#import "Strings.h"


@interface PearlStrings : Strings {

}

+ (PearlStrings *)get;

@property (nonatomic, readonly) NSString *timeDaySuffix;
@property (nonatomic, readonly) NSString *timeDaySuffixOne;
@property (nonatomic, readonly) NSString *timeDaySuffixTwo;
@property (nonatomic, readonly) NSString *timeDaySuffixThree;
@property (nonatomic, readonly) NSString *fontSizeSmall;
@property (nonatomic, readonly) NSString *fontSizeNormal;
@property (nonatomic, readonly) NSString *fontSizeLarge;
@property (nonatomic, readonly) NSString *fontFamilyDefault;
@property (nonatomic, readonly) NSString *fontFamilyFixed;
@property (nonatomic, readonly) NSString *fontFamilySymbolic;
@property (nonatomic, readonly) NSString *songSequential;
@property (nonatomic, readonly) NSString *songRandom;
@property (nonatomic, readonly) NSString *songOff;
@property (nonatomic, readonly) NSString *commonTitleNotice;
@property (nonatomic, readonly) NSString *commonTitleError;
@property (nonatomic, readonly) NSString *commonButtonOkay;
@property (nonatomic, readonly) NSString *commonButtonNext;
@property (nonatomic, readonly) NSString *commonButtonDone;
@property (nonatomic, readonly) NSString *commonButtonBack;
@property (nonatomic, readonly) NSString *commonButtonRetry;
@property (nonatomic, readonly) NSString *commonButtonCancel;
@property (nonatomic, readonly) NSString *commonButtonContinue;
@property (nonatomic, readonly) NSString *commonButtonAbort;
@property (nonatomic, readonly) NSString *commonButtonUpgrade;
@property (nonatomic, readonly) NSString *commonButtonYes;
@property (nonatomic, readonly) NSString *commonButtonNo;
@property (nonatomic, readonly) NSString *commonButtonNoKind;
@property (nonatomic, readonly) NSString *commonButtonSave;
@property (nonatomic, readonly) NSString *commonButtonSure;
@property (nonatomic, readonly) NSString *commonButtonThanks;

@end
