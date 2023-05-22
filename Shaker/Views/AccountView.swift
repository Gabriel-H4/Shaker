//
//  AccountView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/20/23.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject private var authInator: AuthenticationInator
    
    @Environment(\.dismiss) var dismiss
    @State private var isShowingAuthScreen = false
    @State private var isShowingOnboarding = false
    @StateObject var authManager = AuthenticationInator.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label("My Account", systemImage: "person.crop.circle")
                        .font(.title)
                    .padding(.vertical, 15)
                }
                Section {
                    Button("Present Onboarding") {
                        isShowingOnboarding = true
                    }
                    .fullScreenCover(isPresented: $isShowingOnboarding) {
                        OnboardingView()
                    }
                    Button("Log Out & Dismiss") {
                        authInator.resetNeedsAuthentication()
                        dismiss()
                    }
                    Button("Request Authentication") {
                        authInator.resetNeedsAuthentication()
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
                } header: {
                    Label("Debug Options", systemImage: "slider.vertical.3")
                }
                Section {
                    Text(LoggingInator.logFile.absoluteString)
                    Text("Onboarding Status")
                        .contextMenu {
                            Text("Presented v\(OnboardingInfo.previousVersion)")
                            Text("Currently in v\(OnboardingInfo.currentVersion)")
                            Text("Presented new version: \(OnboardingInfo.didPresentCurrentOnboarding.description)")
                        }
                } header: {
                    Label("Debug Info", systemImage: "ant.fill")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
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
            .previewDisplayName("Account View")
    }
}
