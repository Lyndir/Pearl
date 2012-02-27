//
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import <Foundation/Foundation.h>
#import "Strings.h"


@interface PearlCocos2DStrings : PearlAbstractStrings {

}

+ (PearlCocos2DStrings *)get;

@property (nonatomic, readonly) NSString *menuConfig;
@property (nonatomic, readonly) NSString *menuConfigMusic;
@property (nonatomic, readonly) NSString *menuConfigOff;
@property (nonatomic, readonly) NSString *menuConfigOn;
@property (nonatomic, readonly) NSString *menuConfigSound;
@property (nonatomic, readonly) NSString *menuConfigWifi;
@property (nonatomic, readonly) NSString *menuConfigWifiCarrier;
@property (nonatomic, readonly) NSString *menuGameEnd;
@property (nonatomic, readonly) NSString *menuGameNew;
@property (nonatomic, readonly) NSString *menuMoreGames;
@property (nonatomic, readonly) NSString *menuScores;
@property (nonatomic, readonly) NSString *menuLevelRestart;
@property (nonatomic, readonly) NSString *menuLevelRetry;
@property (nonatomic, readonly) NSString *menuMain;
@property (nonatomic, readonly) NSString *messagePaused;
@property (nonatomic, readonly) NSString *messageUnpaused;
@property (nonatomic, readonly) NSString *messageLevel;

@end
