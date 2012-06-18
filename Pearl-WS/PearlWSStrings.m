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


@implementation PearlWSStrings

- (id)init {

    return [super initWithTable:@"PearlWS"];
}

+ (PearlWSStrings *)get {

    static PearlWSStrings *instance = nil;
    if (!instance)
        instance = [self new];

    return instance;
}

@dynamic errorWSConnection;
@dynamic errorWSResponseInvalid;
@dynamic errorWSResponseFailed;
@dynamic errorWSResponseOutdatedRequired;
@dynamic errorWSResponseOutdatedOptional;

@end
