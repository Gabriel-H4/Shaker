//
//  Components.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 5/20/23.
//

import SwiftUI

struct CredentialRowItem: View {
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var authInator: AuthenticationInator
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
        .contextMenu {
            if !authInator.needsAuthentication {
                Button(role: .none) {
                    item.isPinned.toggle()
                    ContainerInator.shared.save()
                } label: {
                    item.isPinned ? Label("Un-pin", systemImage: "pin.slash.fill") : Label("Pin", systemImage: "pin.fill")
                }
                Divider()
                Button(role: .destructive) {
                    moc.delete(item)
                    ContainerInator.shared.save()
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
        } preview: {
            DetailView(selectedCredential: item)
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
