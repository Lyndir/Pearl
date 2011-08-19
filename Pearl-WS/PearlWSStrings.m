//
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import "PearlWSStrings.h"


@implementation PearlWSStrings

- (id)init {

    return [super initWithTable:@"PearlWS"];
}

+ (PearlWSStrings *)get {

    static PearlWSStrings *pearlWSStrings = nil;
    if (pearlWSStrings == nil)
        pearlWSStrings = [PearlWSStrings new];

    return pearlWSStrings;
}

@dynamic errorWSConnection;
@dynamic errorWSResponseInvalid;
@dynamic errorWSResponseOutdatedRequired;
@dynamic errorWSResponseOutdatedOptional;

@end
