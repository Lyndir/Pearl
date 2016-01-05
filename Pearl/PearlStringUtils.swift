//
// Created by Maarten Billemont on 2015-12-18.
// Copyright (c) 2015 Maarten Billemont. All rights reserved.
//

import Foundation

func strf(format: String, _ args: Any?...) -> String {
    return withAnyVaList( args ) {
        return NSString( format: format, arguments: $0 ) as String
    }
}

func strl(format: String, _ args: CVarArgType...) -> String {
    return withVaList( args ) {
        return NSString( format: NSBundle.mainBundle().localizedStringForKey( format, value: nil, table: nil ),
                         arguments: $0 ) as String
    }
}

func strtl(tableName: String, format: String, _ args: CVarArgType...) -> String {
    return withVaList( args ) {
        return NSString( format: NSBundle.mainBundle().localizedStringForKey( format, value: nil, table: tableName ),
                         arguments: $0 ) as String
    }
}
