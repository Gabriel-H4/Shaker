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
    @StateObject var authManager = AuthenticationInator.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(selectedCredential.title ?? "Nil")
                    Text(selectedCredential.id.hashValue.description)
                } header: {
                    Text("ID")
                }
                Section {
                    Text(selectedCredential.username ?? "Nil")
                    Text(selectedCredential.value ?? "Nil")
                        .fontWeight(.thin)
                        .monospaced()
                } header: {
                    Text("Username & Value")
                }
                Section {
                    Text(selectedCredential.isPinned.description.capitalized)
                } header: {
                    Text("Pinned")
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
    
    static let moc = ContainerInator.preview.container.viewContext
    
    static var previews: some View {
        
        let cred = Password(context: moc)
        cred.title = "FooBarBaz"
        cred.username = "user"
        cred.value = "password01"
        cred.isPinned = false
        
        return DetailView(selectedCredential: cred)
            .previewDisplayName("Detail View")
        
    }
}
