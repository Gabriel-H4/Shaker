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
            LoggingInator.log(.runtime, .function, .info, "Request to delete a credential was processed")
        }
        ContainerInator.shared.save()
    }
    
    @EnvironmentObject private var authInator: AuthenticationInator
    
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
    
    var body: some View {
        NavigationStack {
            List {
                if authInator.needsAuthentication || credentials.isEmpty {
                    Section {
                        if authInator.needsAuthentication {
                            InfoRowItem(message: "Log in to continue.")
                        }
                        if credentials.isEmpty {
                            InfoRowItem(message: "Add a Credential to get started!")
                        }
                    } header: {
                        Text("Info")
                    }
                }
                if !credentials.isEmpty {
                    Section {
                        ForEach(credentials) { credential in
                            CredentialRowItem(item: credential)
                            .contextMenu {
                                if !authInator.needsAuthentication {
                                    Button(role: .none) {
                                        credential.isPinned.toggle()
                                        ContainerInator.shared.save()
                                    } label: {
                                        credential.isPinned ? Label("Un-pin", systemImage: "pin.slash.fill") : Label("Pin", systemImage: "pin.fill")
                                    }
                                    Divider()
                                    Button(role: .destructive) {
                                        moc.delete(credential)
                                        ContainerInator.shared.save()
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                            } preview: {
                                DetailView(selectedCredential: credential)
                            }
                        }
                        .onDelete(perform: removeCredentials)
                        .deleteDisabled(authInator.needsAuthentication)
                        .disabled(authInator.needsAuthentication)
                        .redacted(reason: authInator.needsAuthentication ? .privacy : [])
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
                    .disabled(authInator.needsAuthentication)
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
        }
        .onAppear {
            LoggingInator.log(.runtime, .view, .info, "HomeView appeared")
            if authInator.needsAuthentication {
                isShowingUserAuthView = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthenticationInator.shared)
            .previewDisplayName("Home View")
    }
}
