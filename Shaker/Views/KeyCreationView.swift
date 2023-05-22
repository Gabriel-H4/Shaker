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
    @State var value: String = ""
    @State var isPinned: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Username", text: $username)
                    .autocorrectionDisabled()
                    .textContentType(.username)
                TextField("Token", text: $value)
                    .autocorrectionDisabled()
                    .textContentType(.newPassword)
                Toggle(isOn: $isPinned) {
                    Text("Pinned")
                }
            }
            .textInputAutocapitalization(.never)
            Spacer()
            Button("Save") {
                let newCredential = Password(context: moc)
                newCredential.title = title
                newCredential.username = username
                newCredential.value = value
                newCredential.isPinned = isPinned
                ContainerInator.shared.save()
                dismiss()
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
        KeyCreationView(title: "FooBarPreview", username: "prev", value: "pass", isPinned: false)
            .previewDisplayName("Key Creation View")
    }
}
