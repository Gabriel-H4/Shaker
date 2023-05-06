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
    // TODO: Add user-defined sorting method
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.isPinned, order: SortOrder.reverse),
        SortDescriptor(\.title)
    ]) private var credentials: FetchedResults<Credential>
    @State private var isShowingAccountView = false
    @State private var isShowingCreationView = false
    @State private var isShowingUserAuthView = false
    @StateObject private var authManager = AuthenticationInator.shared
    
    var body: some View {
        NavigationStack {
            List {
                if authManager.needsAuthentication || credentials.isEmpty {
                    Section {
                        if authManager.needsAuthentication {
                            Label("Log in to continue", systemImage: "info.circle")
                        }
                        if credentials.isEmpty {
                            Label("Add a Credential to get started!", systemImage: "info.circle")
                        }
                    } header: {
                        Text("Info")
                    }
                }
                if !credentials.isEmpty {
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
            }
            .navigationTitle("Shaker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Credential") {
                            isShowingCreationView = true
                        }
                    } label: {
                        Label("Create New", systemImage: "plus.circle.fill")
                            .labelStyle(.iconOnly)
                    }
                    .disabled(authManager.needsAuthentication)
                }
                ToolbarItem(placement: .secondaryAction) {
                    Button {
                        isShowingAccountView = true
                    } label: {
                        Label("Account", systemImage: "person.crop.circle")
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowingAccountView) {
                AccountView()
            }
            .sheet(isPresented: $isShowingCreationView) {
                KeyCreationView()
            }
        }
        .fullScreenCover(isPresented: $isShowingUserAuthView) {
            UserAuthenticationView()
                .environmentObject(authManager)
        }
        .onAppear {
            if authManager.needsAuthentication {
                isShowingUserAuthView = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDisplayName("Home View")
    }
}
