//
// Created by Maarten Billemont on 2015-12-18.
// Copyright (c) 2015 Maarten Billemont. All rights reserved.
//

import Foundation

extension PearlLogLevel: Strideable, CaseIterable, CustomStringConvertible {
    public private(set) static var allCases = [ PearlLogLevel ]( (.trace)...(.fatal) )

    public func distance(to other: PearlLogLevel) -> Int {
        Int( other.rawValue ) - Int( self.rawValue )
    }

    public func advanced(by n: Int) -> PearlLogLevel {
        PearlLogLevel( rawValue: UInt( Int( self.rawValue ) + n ) )!
    }

    public var description: String {
        switch self {
            case .trace:
                return "Trace"
            case .debug:
                return "Debug"
            case .info:
                return "Info"
            case .warn:
                return "Warn"
            case .error:
                return "Error"
            case .fatal:
                return "Fatal"
            @unknown default:
                fatalError( "Unsupported log level: \(self.rawValue)" )
        }
    }

    public var short: String {
        String( validatingUTF8: PearlLogLevelStr( self ) )!
    }
}

@discardableResult
public func trc(_ message: String,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger? {
    log( message, level: .trace, inFile: file, atLine: line, fromFunction: f );
}

@discardableResult
public func dbg(_ message: String,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger? {
    log( message, level: .debug, inFile: file, atLine: line, fromFunction: f );
}

@discardableResult
public func inf(_ message: String,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger? {
    log( message, level: .info, inFile: file, atLine: line, fromFunction: f );
}

@discardableResult
public func wrn(_ message: String,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger? {
    log( message, level: .warn, inFile: file, atLine: line, fromFunction: f );
}

@discardableResult
public func err(_ message: String,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger? {
    log( message, level: .error, inFile: file, atLine: line, fromFunction: f );
}

@discardableResult
public func ftl(_ message: String,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger? {
    log( message, level: .fatal, inFile: file, atLine: line, fromFunction: f );
}

@discardableResult
public func log(_ message: String, level: PearlLogLevel,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger? {
    log( format: "%@", message, level: level, inFile: file, atLine: line, fromFunction: f );
}

@discardableResult
public func log(format: String, _ args: Any?..., level: PearlLogLevel,
                inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlLogger? {
    if PearlLogger.get().minimumLevel.rawValue > level.rawValue {
        return nil;
    }

    return withAnyVaList( args: args ) {
        PearlLogger.get().inFile( NSURL( fileURLWithPath: file ).lastPathComponent!, atLine: line, fromFunction: f,
                                  with: level, format: format, args: $0 )
    }
}

private func withAnyVaList<R>(args: [Any?], _ f: (CVaListPointer) -> R) -> R {
    withVaList( args.map( { ($0 ?? "<nil>" as NSString) as? CVarArg ?? "<not an object>" } ), f )
}
