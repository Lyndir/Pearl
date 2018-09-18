//
// Created by Maarten Billemont on 2018-09-17.
// Copyright (c) 2018 Lyndir. All rights reserved.
//

import Foundation

/** Define a new profiler in this scope. */
public func prof_new(_ message: String,
                     inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) -> PearlProfiler {
    return PearlProfiler( inFile: file, atLine: line, fromFunction: f, forTask: message );
}

/** Rewind a profiler's time and log the duration, starting anew. */
public func prof_rewind(_ profiler: PearlProfiler, _ message: String,
                        inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) {
    profiler.rewind(inFile: file, atLine: line, fromFunction: f, jobName: message)
}

/** Finish a profiler's time and log the duration and the total profiler time. */
public func prof_finish(_ profiler: PearlProfiler, _ message: String,
                        inFile file: String = #file, atLine line: Int = #line, fromFunction f: String = #function) {
    profiler.finish(inFile: file, atLine: line, fromFunction: f, jobName: message)
}
