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
    @EnvironmentObject var authInator: AuthenticationInator
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(systemName: authInator.needsAuthentication ? "lock.fill" : "lock.open")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100.0)
                    .padding()
                if authInator.needsAuthentication {
                    switch(authInator.biometryType) {
                    case .faceID:
                        Text("Unlock with FaceID")
                    case .touchID:
                        Text("Unlock with TouchID")
                    default:
                        Text("Please authenticate using your device credentials")
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button("Close") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                    Button("Authenticate") {
                        Task.init {
                            await authInator.authenticateWithBiometrics()
                            guard authInator.needsAuthentication else {
                                LoggingInator.log(.runtime, .view, .info, "Authentication was successful, dismissing view")
                                dismiss()
                                return
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
            }
            .navigationTitle("Authenticate")
            .padding()
        }
        .onAppear {
            LoggingInator.log(.runtime, .view, .info, "UserAuthenticationView appeared")
            Task.init {
                await authInator.authenticateWithBiometrics()
                guard authInator.needsAuthentication else {
                    dismiss()
                    return
                }
            }
        }
    }
    
    struct UserAuthenticationView_Previews: PreviewProvider {
        static var previews: some View {
            UserAuthenticationView()
                .environmentObject(AuthenticationInator.shared)
                .previewDisplayName("User Authentication View")
        }
    }
}
