//
//  HomeView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/2/23.
//

import SwiftUI

struct HomeView: View {
    
    func removeCredentials(at offsets: IndexSet) {
        for index in offsets {
            let credential = credentials[index]
            moc.delete(credential)
        }
        do {
            try moc.save()
        }
        catch {
            fatalError("There was a problem saving the deletion(s), with error: \(error.localizedDescription)")
        }
    }
    
    // Core Data
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var credentials: FetchedResults<Credential>
    
    @StateObject var authManager = AuthenticationManager.shared
    @State private var isShowingAuthScreen = false
    @State private var isShowingOnboarding = false
    @State private var isShowingCreationView = false
    
    var body: some View {
        NavigationStack {
            List {
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
//                        CloudKitManager.writeData()
                    }
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: "app-settings:")!)
                    }
                }
                // TODO: Add user-defined sorting method
                Section {
                    ForEach(credentials) { credential in
                        NavigationLink(destination: DetailView(selectedCredential: credential)) {
                            Label(credential.title ?? "No Title", systemImage: credential.isPinned ? "pin.fill" : "key.fill")
                                .privacySensitive()
                                .swipeActions(edge: .leading) {
                                    Button(role: .none) {
                                        credential.isPinned.toggle()
                                        try? moc.save()
                                    } label: {
                                        credential.isPinned ? Label("Un-pin", systemImage: "pin.slash.fill") : Label("Pin", systemImage: "pin.fill")
                                    }
                                    .tint(.yellow)
                                }
                        }
                        .contextMenu {
                            if !authManager.needsAuthentication {
                                Button(role: .none) {
                                    credential.isPinned.toggle()
                                    try? moc.save()
                                } label: {
                                    credential.isPinned ? Label("Un-pin", systemImage: "pin.slash.fill") : Label("Pin", systemImage: "pin.fill")
                                }
                                Divider()
                                Button(role: .destructive) {
                                    moc.delete(credential)
                                    try? moc.save()
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        } preview: {
                            DetailView(selectedCredential: credential)
                        }
                    }
                    .onDelete(perform: removeCredentials)
                    .deleteDisabled(authManager.needsAuthentication)
                    .disabled(authManager.needsAuthentication)
                    .redacted(reason: authManager.needsAuthentication ? .privacy : [])
                } header: {
                    Text("Core Data")
                }
            }
            .navigationTitle("Shaker")
            .toolbar {
                Image(systemName: "person.circle")
                    .padding(.trailing, 10)
                Menu {
                    Button("Credential") {
                        isShowingCreationView = true
                    }
                } label: {
                    Label("Create New", systemImage: "plus.circle.fill")
                }
                .disabled(authManager.needsAuthentication)
            }
            .sheet(isPresented: $isShowingCreationView) {
                KeyCreationView()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
