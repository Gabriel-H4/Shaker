//
//  DetailView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/30/23.
//

import CoreData
import SwiftUI

struct DetailView: View {
    
    let selectedCredential: Credential
    @StateObject var authManager = AuthenticationManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(selectedCredential.title ?? "No Title")
                    Text(selectedCredential.id?.description ?? "0")
                } header: {
                    Text("Title & ID")
                }
                Section {
                    Text(selectedCredential.username ?? "")
                    Text(selectedCredential.token ?? "")
                        .fontWeight(.thin)
                        .monospaced()
                } header: {
                    Text("Username & Token")
                }
                Section {
                    Text(selectedCredential.isPinned.description.capitalized)
                    Text(selectedCredential.type?.capitalized ?? "Type not found")
                } header: {
                    Text("Favorite & Type")
                }
            }
            .textSelection(.enabled)
            .disabled(authManager.needsAuthentication)
            .privacySensitive()
            .redacted(reason: authManager.needsAuthentication ? .privacy : [])
            .navigationTitle("Details")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static let moc = DataInator().container.viewContext
    
    static var previews: some View {
        
        let cred = Credential(context: moc)
        cred.id = UUID()
        cred.title = "FooBarBaz"
        cred.username = "user"
        cred.token = "password01"
        cred.isPinned = false
        cred.url = "https://example.com"
        
        return DetailView(selectedCredential: cred)
            .previewDisplayName("Detail View")
        
    }
}
