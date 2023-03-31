//
//  HomeView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/2/23.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    
    @EnvironmentObject var realmManager: RealmManager
    @ObservedResults(AuthKey.self) var allAuthKeys
    @StateObject var authManager = AuthenticationManager.shared
    @State private var isShowingAuthScreen = false
    
    var body: some View {
        NavigationStack {
            List {
                Button("Create new") {
                    $allAuthKeys.append(AuthKey(title: "NewKey", username: "Foo", password: "BarBaz123", favorite: false))
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
                Button("Settings") {
                    UIApplication.shared.open(URL(string: "app-settings:")!)
                }
                // TODO: Add user-defined sorting method
                ForEach(allAuthKeys.sorted(by: { $0.isFavorite && !$1.isFavorite } )) { authKey in
                    // TODO: Revamp this, eventually convert into NavigationLink cells
                    NavigationLink(destination: DetailView(selectedKey: authKey)) {
                        Label(authKey.title, systemImage: authKey.isFavorite ? "star.fill" : "key.fill")
                            .privacySensitive()
                            .redacted(reason: authManager.needsAuthentication ? .privacy : [])
                            .swipeActions(edge: .leading) {
                                Button(role: .none) {
                                    realmManager.toggleAuthKeyFavoriteStatus(key: authKey)
                                } label: {
                                    authKey.isFavorite ? Label("Un-favorite", systemImage: "star.slash.fill") : Label("Favorite", systemImage: "star.fill")
                                }
                                .tint(.yellow)
                            }
                    }
                }
                .onDelete(perform: $allAuthKeys.remove)
                .deleteDisabled(authManager.needsAuthentication)
                .disabled(authManager.needsAuthentication)
            }
            .navigationTitle("Shaker")
            .toolbar {
                Menu {
                    Button("Password") {
                        $allAuthKeys.append(AuthKey(title: "Foo", username: "Bar", password: "Baz123", favorite: false))
                    }
                } label: {
                    Label("Create New", systemImage: "plus.circle.fill")
                }
                .disabled(authManager.needsAuthentication)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(RealmManager())
    }
}
