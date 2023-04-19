//
//  OnboardingCardView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/18/23.
//

import SwiftUI

struct OnboardingCardView: View {
    
    @State var currentItem: OnboardingItem
    @State private var selectedOption = 1
    @State private var isShowingDetailSheet = false
    
    var body: some View {
        VStack {
            Image(systemName: currentItem.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 128)
                .padding(.top, 30)
            Text(currentItem.title)
                .font(.largeTitle)
                .padding(.vertical, 20)
            Text(currentItem.description)
                .padding()
            if let details = currentItem.moreDetails {
                Button("Learn more...") {
                    isShowingDetailSheet = true
                }
                .sheet(isPresented: $isShowingDetailSheet) {
                    OnboardingDetailView(currentItem: currentItem, detail: details)
                }
            }
            Spacer()
            if let opts = currentItem.options {
                Picker("Data", selection: $selectedOption) {
                    ForEach(opts) { option in
                        Text(option.text)
                            .tag(option.tag)
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(.bottom, 20)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .cornerRadius(20)
        .padding(20)
    }
}

struct OnboardingCardView_Previews: PreviewProvider {
    static var previews: some View {
        let demoItem = OnboardingItem(title: "Foo", tag: 1, description: "Here's a description", moreDetails: "This is a bunch of *extra* detail, that helps explain what this option does.", icon: "star.fill", options: nil, versionIntroduced: "0.0.1")
        OnboardingCardView(currentItem: demoItem)
    }
}
