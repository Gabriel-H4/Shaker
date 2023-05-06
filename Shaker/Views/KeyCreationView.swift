//
//  KeyCreationView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/8/23.
//

import SwiftUI

struct KeyCreationView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @State var title: String = ""
    @State var username: String = ""
    @State var token: String = ""
    @State var url: String = ""
    @State var isPinned: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Username", text: $username)
                    .autocorrectionDisabled()
                    .textContentType(.username)
                TextField("Token", text: $token)
                    .autocorrectionDisabled()
                    .textContentType(.newPassword)
                TextField("URL", text: $url)
                    .autocorrectionDisabled()
                    .textContentType(.URL)
                Toggle(isOn: $isPinned) {
                    Text("Pinned")
                }
            }
            .textInputAutocapitalization(.never)
            Spacer()
            Button("Save") {
                let newCredential = Credential(context: moc)
                newCredential.id = UUID()
                newCredential.title = title
                newCredential.username = username
                newCredential.token = token
                newCredential.isPinned = isPinned
                newCredential.type = CredType.credential.rawValue
                do {
                    try moc.save()
                    dismiss()
                }
                catch {
                    fatalError("There was a problem saving the new Credential with error: \(error.localizedDescription)")
                }
            }
            .padding(.bottom, 10)
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .navigationTitle("New Credential")
        }
    }
}

struct KeyCreationView_Previews: PreviewProvider {
    static var previews: some View {
        KeyCreationView(title: "FooBarPreview", username: "prev", token: "pass", url: "example.com", isPinned: false)
            .previewDisplayName("Key Creation View")
    }
}
