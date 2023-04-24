//
//  AccountView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/20/23.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isShowingAuthScreen = false
    @State private var isShowingOnboarding = false
    @StateObject var authManager = AuthenticationManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label("My Account", systemImage: "person.crop.circle")
                        .font(.title)
                    .padding(.vertical, 15)
                }
                Section {
                    Text("Presented OB App Version: \(OnboardingInfo().previousVersion)")
                    Text("Running App Version: \(OnboardingInfo().currentVersion)")
                    Text(OnboardingInfo().didPresentCurrentOnboarding ? "Current OB was shown!" : "Onboarding was Updated!")
                } header: {
                    Text("Onboarding Status")
                }
                Section {
                    Button("Onboarding") {
                        isShowingOnboarding = true
                    }
                    .fullScreenCover(isPresented: $isShowingOnboarding) {
                        OnboardingView()
                    }
                    Button("Log Out") {
                        authManager.needsAuthentication = true
                    }
                    Button("Log in") {
                        authManager.needsAuthentication = true
                        isShowingAuthScreen = true
                    }
                    .fullScreenCover(isPresented: $isShowingAuthScreen) {
                        UserAuthenticationView()
                            .environmentObject(authManager)
                    }
                    Button("Write to iCloud") {
                        
                    }
                    .disabled(true)
                    Button("Shaker iOS Settings") {
                        UIApplication.shared.open(URL(string: "app-settings:")!)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .clipShape(Circle())
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
