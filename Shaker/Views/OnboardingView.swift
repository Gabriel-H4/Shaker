//
//  OnboardingView.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/2/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var tabSelection = 1
    private var filteredOnboardingData = filterOnboardingData() ?? []
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelection) {
                if !filteredOnboardingData.isEmpty {
                    ForEach(filteredOnboardingData) { item in
                        OnboardingCardView(currentItem: item)
                            .tag(item.tag)
                    }
                }
                else {
                    Text("You're up-to-date!")
                }
            }
            .tabViewStyle(.page)
            HStack {
                if tabSelection > 1 {
                    Button {
                        tabSelection -= 1
                    } label: {
                        Label("", systemImage: "arrow.left")
                            .labelStyle(.iconOnly)
                            .padding(5)
                    }
                    .clipShape(Circle())
                    .buttonStyle(.bordered)
                    .padding(.trailing, 10)
                }
                Button {
                    if tabSelection < filteredOnboardingData.count {
                        tabSelection += 1
                    }
                    else {
                        UserDefaults.standard.set(OnboardingInfo().currentVersion, forKey: "previousVersion")
                        UserDefaults.standard.set(true, forKey: "didPresentCurrentOnboarding")
                        self.dismiss()
                    }
                } label: {
                    HStack {
                        (tabSelection < filteredOnboardingData.count) ? Text("Continue") : Text("Finish")
                        Image(systemName: "arrow.right")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
            }
            .imageScale(.large)
            .buttonBorderShape(.capsule)
            .padding(.bottom, 10)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
