//
//  AuthenticationManager.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/27/23.
//

import Foundation
import LocalAuthentication

class AuthenticationManager: ObservableObject {
    
    static let shared = AuthenticationManager()
    
    private(set) var context = LAContext()
    private(set) var canEvaluatePolicy = false
    @Published private(set) var biometryType: LABiometryType = .none
    @Published private(set) var errorDescription: String?
    @Published var needsAuthentication = true
    
    private init() {
        getBiometryType()
    }
    
    func getBiometryType() {
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        biometryType = context.biometryType
    }
    
    func authenticateWithBiometrics() async {
        context = LAContext()
        
        if canEvaluatePolicy {
            let reason = "Unlock Shaker to access your data"
            
            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
                if success {
                    DispatchQueue.main.async {
                        self.needsAuthentication = false
                    }
                }
            }
            catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorDescription = error.localizedDescription
                    self.biometryType = .none
                }
            }
        }
    }
}

