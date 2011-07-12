//
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import "PearlCocos2DStrings.h"


@implementation PearlCocos2DStrings

- (id)init {

    return [super initWithTable:@"Pearl-Cocos2D"];
}

+ (PearlCocos2DStrings *)get {

    static PearlCocos2DStrings *pearlStrings = nil;
    if (pearlStrings == nil)
        pearlStrings = [PearlCocos2DStrings new];

    return pearlStrings;
}

@dynamic menuConfig;
@dynamic menuConfigMusic;
@dynamic menuConfigOff;
@dynamic menuConfigOn;
@dynamic menuConfigSound;
@dynamic menuConfigWifi;
@dynamic menuConfigWifiCarrier;
@dynamic menuGameEnd;
@dynamic menuGameNew;
@dynamic menuMoreGames;
@dynamic menuScores;
@dynamic menuLevelRestart;
@dynamic menuLevelRetry;
@dynamic menuMain;
@dynamic messagePaused;
@dynamic messageUnpaused;
@dynamic messageLevel;

@end
