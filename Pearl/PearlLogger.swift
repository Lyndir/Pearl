//
// Created by Maarten Billemont on 2015-12-18.
// Copyright (c) 2015 Maarten Billemont. All rights reserved.
//

import Foundation

public func trc(format: String, _ args: Any?...,
                inFile file: String = __FILE__, atLine line: Int = __LINE__, fromFunction f: String = __FUNCTION__) -> PearlLogger {
    return withAnyVaList( args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  withLevel: PearlLogLevel.Trace, format: format, args: $0 )
    }
}

public func dbg(format: String, _ args: Any?...,
                inFile file: String = __FILE__, atLine line: Int = __LINE__, fromFunction f: String = __FUNCTION__) -> PearlLogger {
    return withAnyVaList( args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  withLevel: PearlLogLevel.Debug, format: format, args: $0 )
    }
}

public func inf(format: String, _ args: Any?...,
                inFile file: String = __FILE__, atLine line: Int = __LINE__, fromFunction f: String = __FUNCTION__) -> PearlLogger {
    return withAnyVaList( args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  withLevel: PearlLogLevel.Info, format: format, args: $0 )
    }
}

public func wrn(format: String, _ args: Any?...,
                inFile file: String = __FILE__, atLine line: Int = __LINE__, fromFunction f: String = __FUNCTION__) -> PearlLogger {
    return withAnyVaList( args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  withLevel: PearlLogLevel.Warn, format: format, args: $0 )
    }
}

public func err(format: String, _ args: Any?...,
                inFile file: String = __FILE__, atLine line: Int = __LINE__, fromFunction f: String = __FUNCTION__) -> PearlLogger {
    return withAnyVaList( args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  withLevel: PearlLogLevel.Error, format: format, args: $0 )
    }
}

public func ftl(format: String, _ args: Any?...,
                inFile file: String = __FILE__, atLine line: Int = __LINE__, fromFunction f: String = __FUNCTION__) -> PearlLogger {
    return withAnyVaList( args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  withLevel: PearlLogLevel.Fatal, format: format, args: $0 )
    }
}

public func withAnyVaList<R>(args: [Any?], _ f: (CVaListPointer) -> R) -> R {
    return withVaList( args.map( { return ($0 ?? "<nil>" as NSString) as? CVarArgType ?? "<not an object>" } ), f )
}
