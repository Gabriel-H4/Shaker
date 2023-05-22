//
//  Components.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 5/20/23.
//

import SwiftUI

struct CredentialRowItem: View {
    
    @StateObject var item: Credential
    
    var body: some View {
        NavigationLink(destination: DetailView(selectedCredential: item)) {
            Label(item.title ?? "Unknown", systemImage: item.isPinned ? "pin.fill" : "key.fill")
                .privacySensitive()
                .swipeActions(edge: .leading) {
                    Button(role: .none) {
                        item.isPinned.toggle()
                        ContainerInator.shared.save()
                    } label: {
                        item.isPinned ? Label("Un-pin", systemImage: "pin.slash.fill") : Label("Pin", systemImage: "pin.fill")
                    }
                    .tint(.yellow)
                }
        }
    }
}

struct InfoRowItem: View {
    
    @State var message: String
    
    var body: some View {
        Label(message, systemImage: "info.circle")
    }
}

struct Components_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
