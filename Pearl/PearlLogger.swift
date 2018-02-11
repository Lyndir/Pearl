//
// Created by Maarten Billemont on 2015-12-18.
// Copyright (c) 2015 Maarten Billemont. All rights reserved.
//

import Foundation

public func trc(format: String, _ args: Any?...,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger {
    return withAnyVaList( args: args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  with: PearlLogLevel.trace, format: format, args: $0 )
    }
}

public func dbg(format: String, _ args: Any?...,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger {
    return withAnyVaList( args: args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  with: PearlLogLevel.debug, format: format, args: $0 )
    }
}

public func inf(format: String, _ args: Any?...,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger {
    return withAnyVaList( args: args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  with: PearlLogLevel.info, format: format, args: $0 )
    }
}

public func wrn(format: String, _ args: Any?...,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger {
    return withAnyVaList( args: args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  with: PearlLogLevel.warn, format: format, args: $0 )
    }
}

public func err(format: String, _ args: Any?...,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger {
    return withAnyVaList( args: args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  with: PearlLogLevel.error, format: format, args: $0 )
    }
}

public func ftl(format: String, _ args: Any?...,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger {
    return withAnyVaList( args: args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent, atLine: line, fromFunction: f,
                                  with: PearlLogLevel.fatal, format: format, args: $0 )
    }
}

public func withAnyVaList<R>(args: [Any?], _ f: (CVaListPointer) -> R) -> R {
    return withVaList( args.map( { return ($0 ?? "<nil>" as NSString) as? CVarArg ?? "<not an object>" } ), f )
}
