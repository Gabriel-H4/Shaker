//
//  DetailView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/30/23.
//

import SwiftUI

struct DetailView: View {
    
    @State var selectedKey: AuthKey
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(selectedKey.title)
                    Text(selectedKey._id.description)
                } header: {
                    Text("Title & ID")
                }
                Section {
                    Text(selectedKey.username ?? "")
                    Text(selectedKey.token ?? "")
                        .fontWeight(.thin)
                        .monospaced()
                } header: {
                    Text("Username & Token")
                }
                Section {
                    Text(selectedKey.isFavorite.description.capitalized)
                } header: {
                    Text("Favorite")
                }
            }
            .navigationTitle("Details")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedKey: AuthKey(title: "Demo Key", username: "demo@example.com", password: "foobarbaz123", favorite: false))
    }
}
