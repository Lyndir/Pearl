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

#import "PearlCocos2DStrings.h"

@implementation PearlCocos2DStrings

- (id)init {

    return [super initWithTable:@"Pearl-Cocos2D"];
}

+ (instancetype)get {

    static PearlCocos2DStrings *instance = nil;
    if (!instance)
        instance = [self new];

    return instance;
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
