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
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelection) {
                ForEach(onboardingFlow) { item in
                    OnboardingCardView(currentItem: item)
                        .tag(item.tag)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
                    if tabSelection < onboardingFlow.count {
                        tabSelection += 1
                    }
                    else {
                        self.dismiss()
                    }
                } label: {
                    HStack {
                        Text("Continue")
                        Image(systemName: "arrow.right")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
            }
            
            .imageScale(.large)
            .buttonBorderShape(.capsule)
        }
    }
}

struct OnboardingCardView: View {
    
    @State var currentItem: OnboardingItem
    
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
                    print(details)
                }
            }
            Spacer()
            // TODO: Change buttons into Picker?
            ForEach(currentItem.options ?? []) { option in
                if option.isPrimary {
                    Button(option.text) {
                        // TODO: Implement prefs interpretation and saving
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button(option.text) {
                        // TODO: Implement prefs interpretation and saving
                    }
                    .buttonStyle(.bordered)
                }
            }
            .buttonBorderShape(.capsule)
            .padding(.bottom, 15)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(.pink)
        .cornerRadius(20)
        .padding(20)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
