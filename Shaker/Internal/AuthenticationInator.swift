//
//  AuthenticationInator.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/27/23.
//

import Foundation
import LocalAuthentication

/// Class to handle authentication and provide key info to views
final class AuthenticationInator: ObservableObject {
    
    // MARK: Variable Definitions
    
    /// A singleton (bad, I know) to ensure the authentication status is shared
    static let shared = AuthenticationInator()
    
    /// The Local Authentication context (biometric type)
    private(set) var context = LAContext()
    
    /// A helper variable to establish if the context policy can be evaluated (user can try to authenticate)
    private(set) var canEvaluatePolicy = false
    
    /// A boolean indicating if Shaker is being run as a SwiftUI Xcode preview
    static var isSwiftPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    // MARK: Published Variable Definitions
    
    /// The current Local Authentication biometric type
    @Published private(set) var biometryType: LABiometryType = .none
    
    /// If there was an error authenticating, this will be populated with that error
    @Published private(set) var errorDescription: String?
    
    /// The current authentication status:
    ///
    /// TRUE (not authenticated    |   FALSE (authenticated)
    @Published private(set) var needsAuthentication: Bool = true
    
    // MARK: Initializer
    
    private init() {
        LoggingInator.log(.runtime, .function, .info, "Began initializing new AuthenticationInator")
        getBiometryType()
        needsAuthentication = determineNeedsAuthentication()
        LoggingInator.log(.runtime, .function, .info, "Finished initializing new AuthenticationInator")
    }
    
    // MARK: Functions
    
    /// Set the `.needsAuthentication` to true
    func resetNeedsAuthentication() {
        self.needsAuthentication = true
    }
    
    /// Evaluate the device's capabilities to update the authentication method
    private func getBiometryType() {
        LoggingInator.log(.runtime, .function, .info, "Detecting biometric authentication type")
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        biometryType = context.biometryType
        LoggingInator.log(.runtime, .function, .info, "Detected biometric authentication type as \(biometryType.rawValue)")
    }
    
    // TODO: Add more triggers to the authentication requirements
    
    /// Evaluate a set of triggers to determine if the user needs to be authenticated
    /// - Returns: A boolean indicating if Shaker should request authentication
    private func determineNeedsAuthentication() -> Bool {
        if AuthenticationInator.isSwiftPreview {
            return false
        }
        
        // Add more cases here, like 5 min timeout, backgrounded/inactive, etc
        
        return true
    }
    
    /// Try letting the user authenticate
    ///
    /// If successful, the `.needsAuthentication` variable will be updated
    func authenticateWithBiometrics() async {
        
        LoggingInator.log(.runtime, .function, .info, "Authentication was requested")
        
        context = LAContext()
        
        if canEvaluatePolicy {
            let reason = "Unlock Shaker to access your data"
            
            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
                if success {
                    DispatchQueue.main.async {
                        self.needsAuthentication = false
                        LoggingInator.log(.runtime, .function, .info, "The user was successfully authenticated")
                    }
                }
                else {
                    LoggingInator.log(.runtime, .function, .warning, "An unsuccessful authentication attempt occurred")
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.errorDescription = error.localizedDescription
                    self.biometryType = .none
                    LoggingInator.log(.runtime, .function, .error, "Authentication failed with an unexpected error: \(error.localizedDescription)")
                }
            }
        }
        else {
            LoggingInator.log(.runtime, .function, .warning, "Could not evaluate authentication policy")
        }
        LoggingInator.log(.runtime, .function, .info, "Finished processing authentication request")
    }
}

