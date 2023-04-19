//
//  ContentView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/1/23.
//

import SwiftUI
import LocalAuthentication

struct UserAuthenticationView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: authManager.needsAuthentication ? "lock.fill" : "lock.open")
                    .resizable()
                    .scaledToFit()
                    .padding(50)
                    .padding()
                authManager.needsAuthentication ? Text("Please authenticate using your device credentials") : Text("Unlocked")
                Button("Authenticate") {
                    Task.init {
                        await authManager.authenticateWithBiometrics()
                        guard authManager.needsAuthentication else {
                            dismiss()
                            return
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(authManager.needsAuthentication)
            }
            .navigationTitle("Authenticate")
            .padding()
        }
        .onAppear {
            Task.init {
                await authManager.authenticateWithBiometrics()
                guard authManager.needsAuthentication else {
                    dismiss()
                    return
                }
            }
        }
    }
    
    struct UserAuthenticationView_Previews: PreviewProvider {
        static var previews: some View {
            UserAuthenticationView()
                .environmentObject(AuthenticationManager.shared)
        }
    }
}
