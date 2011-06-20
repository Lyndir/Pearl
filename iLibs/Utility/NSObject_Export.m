//
//  NSObject_Export.m
//  RedButton
//
//  Created by Maarten Billemont on 16/06/11.
//  Copyright 2011 Lin.K. All rights reserved.
//

#import "NSObject_Export.h"
#import "Logger.h"


@implementation NSObject (NSObject_Export)

- (id)exportToCodable {
    
    return [NSObject exportToCodable:self];
}

+ (id)exportToCodable:(id)object {
    
    // nil to NSNull.
    if (!object)
        return [NSNull null];
    
    // NSCoding compliant object.
    if ([object conformsToProtocol:@protocol(NSCoding)]) {
        
        // Check collections to make sure their elements are compliant.
        if ([object isKindOfClass:[NSArray class]]) {
            BOOL codable = YES;
            for (NSObject *child in object)
                if (![child conformsToProtocol:@protocol(NSCoding)]) {
                    codable = NO;
                    break;
                }
            if (!codable) {
                NSMutableArray *codableObject = [NSMutableArray arrayWithCapacity:[object count]];
                for (NSObject *child in object)
                    [codableObject addObject:[self exportToCodable:child]];
                object = codableObject;
            }
        }
        if ([object isKindOfClass:[NSSet class]]) {
            BOOL codable = YES;
            for (NSObject *child in object)
                if (![child conformsToProtocol:@protocol(NSCoding)]) {
                    codable = NO;
                    break;
                }
            if (!codable) {
                NSMutableSet *codableObject = [NSMutableSet setWithCapacity:[object count]];
                for (NSObject *child in object)
                    [codableObject addObject:[self exportToCodable:child]];
                object = codableObject;
            }
        }
        if ([object isKindOfClass:[NSDictionary class]]) {
            BOOL codable = YES;
            for (NSObject *key in object)
                if (![key conformsToProtocol:@protocol(NSCoding)] ||
                    ![[(NSDictionary *)object objectForKey:key] conformsToProtocol:@protocol(NSCoding)]) {
                    codable = NO;
                    break;
                }
            if (!codable) {
                NSMutableDictionary *codableObject = [NSMutableDictionary dictionaryWithCapacity:[object count]];
                for (NSObject *key in object)
                    [codableObject setObject:[self exportToCodable:[(NSDictionary *)object objectForKey:key]]
                                      forKey:[self exportToCodable:key]];
                object = codableObject;
            }
        }
        
        return object;
    }
    
    // Not-NSCoding compliant object: NSDictionary of properties.
    NSMutableDictionary *codableObject = [NSMutableDictionary dictionary];
    
    for (Class hierarchyClass = [object class]; [hierarchyClass superclass]; hierarchyClass = [hierarchyClass superclass]) {
        NSUInteger propertiesCount;
        objc_property_t *properties = class_copyPropertyList(hierarchyClass, &propertiesCount);
        
        for (NSUInteger p = 0; p < propertiesCount; p++) {
            objc_property_t property = properties[p];
            NSString *propertyName = [[[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding] autorelease];
            
            id propertyValue = [self exportToCodable:[object valueForKey:propertyName]];
            [codableObject setObject:propertyValue forKey:propertyName];
        }
        
        free(properties);
    }
    
    return codableObject;
}

@end
