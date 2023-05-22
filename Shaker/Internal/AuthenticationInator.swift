//
//  AuthenticationInator.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/27/23.
//

import Foundation
import LocalAuthentication

final class AuthenticationInator: ObservableObject {
    
    static let shared = AuthenticationInator()
    
    private(set) var context = LAContext()
    private(set) var canEvaluatePolicy = false
    @Published private(set) var biometryType: LABiometryType = .none
    @Published private(set) var errorDescription: String?
    @Published private(set) var needsAuthentication = true
    
    private init() {
        LoggingInator.log(.runtime, .function, .info, "Began initializing new AuthenticationInator")
        getBiometryType()
        LoggingInator.log(.runtime, .function, .info, "Finished initializing new AuthenticationInator")
    }
    
    func resetNeedsAuthentication() {
        self.needsAuthentication = true
    }
    
    func getBiometryType() {
        LoggingInator.log(.runtime, .function, .info, "Detecting biometric authentication type")
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        biometryType = context.biometryType
        LoggingInator.log(.runtime, .function, .info, "Detected biometric authentication type as \(biometryType.rawValue)")
    }
    
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

