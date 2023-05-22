//
//  LoggingInator.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 5/10/23.
//

import Foundation

/// Helper structure to record specified events to a log file
struct LoggingInator {
    
    /// The absolute path of the generated log file
    static let logFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("shaker-runtime.log", conformingTo: .log)
    
    /// Various phases Shaker goes through, when events may be logged
    enum AppPhase {
        
        /// The app has fully launched
        case runtime
        
        /// The app is currently being launched, or is not yet interactable
        case setup
        
        /// The app is expecting to end soon
        case teardown
        
    }
    
    /// The various elements requesting to write a new log entry
    enum CallerType {
        
        /// A generic part of the app is generating an event to log
        case app
        
        /// A helper function is generating an event to log
        case function
        
        /// A unit test is generating an event to log
        case test
        
        /// A view is generating an event to log
        case view
        
    }
    
    /// The type of log item being generated
    enum Status {
        
        /// The event being logged demonstrates an error within the app
        case error
        
        /// The event is being logged for debugging purposes
        case debug
        
        /// The event being logged is general information
        case info
        
        /// The event being logged demonstrates a potential error within the app
        case warning
        
    }
    
    /// Generate and write an event to the predetermined log file
    /// - Parameters:
    ///   - phase: The phase the app is currently in when the event occurred
    ///   - callerType: The caller's type
    ///   - status: The type of log item being generatede
    ///   - event: The message representing the event to be written
    static func log(_ phase: AppPhase, _ callerType: CallerType, _ status: Status, _ event: String) {
        let loggedEvent = "\(Date()) [\(status)] [\(phase)] [\(callerType)] \(event)\n"

        do {
            if FileManager.default.fileExists(atPath: logFile.path) {
                let fileHandle = try FileHandle(forWritingTo: logFile)
                try fileHandle.seekToEnd()
                try fileHandle.write(contentsOf: loggedEvent.data(using: .utf8)!)
                try fileHandle.close()
            } else {
                try loggedEvent.data(using: .utf8)?.write(to: logFile)
            }
        }
        catch {
            fatalError("A logging error occurred: \(error.localizedDescription)")
        }
    }
    
    // TODO: Modify to have a single .log call, one that defines the options for a method, and requires a call for something like .didFinish...?
}
