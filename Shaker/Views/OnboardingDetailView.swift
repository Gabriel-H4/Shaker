//
//  OnboardingDetailView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/5/23.
//

import SwiftUI

struct OnboardingDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var currentItem: OnboardingItem
    let detail: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(.init(detail))
                    .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .font(.title2)
                }
            }
            .navigationTitle(currentItem.title)
        }
    }
}

struct OnboardingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let demoItem = OnboardingItem(title: "Foo", tag: 1, description: "Here's a description", moreDetails: "This is a bunch of *extra* detail, that helps explain what this option does.", icon: "star.fill", options: nil, versionIntroduced: "0.0.1")
        OnboardingDetailView(currentItem: demoItem, detail: demoItem.moreDetails!)
            .previewDisplayName("Onboarding Detail View")
    }
}
