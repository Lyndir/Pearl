//
//  Created by lhunath on 11/07/11.
//
//  To change this template use File | Settings | File Templates.
//


#import <Foundation/Foundation.h>


@interface Strings : NSObject {

    NSString                            *_tableName;
}

- (id)initWithTable:(NSString *)tableName;

@property(nonatomic, retain) NSString   *tableName;

@end
