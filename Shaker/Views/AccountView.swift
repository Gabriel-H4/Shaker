//
//  AccountView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/20/23.
//

import CloudKitSyncMonitor
import SwiftUI

func printiCloudError() {
    if SyncMonitor.shared.syncError {
        if let e = SyncMonitor.shared.setupError {
            print("Unable to set up iCloud sync, changes won't be saved! \(e.localizedDescription)")
        }
        if let e = SyncMonitor.shared.importError {
            print("Import is broken: \(e.localizedDescription)")
        }
        if let e = SyncMonitor.shared.exportError {
            print("Export is broken - your changes aren't being saved! \(e.localizedDescription)")
        }
    } else if SyncMonitor.shared.notSyncing {
        print("Sync should be working, but isn't. Look for a badge on Settings or other possible issues.")
    }
}

struct AccountView: View {
    
    @EnvironmentObject private var authInator: AuthenticationInator
    
    @Environment(\.dismiss) var dismiss
    @State private var isShowingAuthScreen = false
    @State private var isShowingOnboarding = false
    @StateObject var authManager = AuthenticationInator.shared
    
    @ObservedObject var syncMonitor = SyncMonitor.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label("My Account", systemImage: "person.crop.circle")
                        .font(.title)
                    .padding(.vertical, 15)
                }
                Section {
                    Label(syncMonitor.syncStateSummary.description, systemImage: syncMonitor.syncStateSummary.symbolName)
                            .foregroundColor(syncMonitor.syncStateSummary.symbolColor)
                    Button("Print iCloud Error") {
                        printiCloudError()
                    }
                } header: {
                    Label("iCloud Status", systemImage: "icloud.fill")
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
                    Label(LoggingInator.logFile.absoluteString, systemImage: "doc.text")
                        .textSelection(.enabled)
                    Label("Onboarding Status", systemImage: "figure.wave")
                        .contextMenu {
                            Text("Presented v\(OnboardingInfo.previousVersion)")
                            Text("Currently in v\(OnboardingInfo.currentVersion)")
                            Text("Presented new version: \(OnboardingInfo.didPresentCurrentOnboarding.description)")
                        }
                    Label(AuthenticationInator.isSwiftPreview ? "Running in SwiftUI Preview" : "Not a SwiftUI Preview", systemImage: "display")
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
