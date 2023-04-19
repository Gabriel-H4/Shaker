//
//  OnboardingData.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/3/23.
//

import Foundation
import SwiftUI

struct OnboardingInfo {
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let previousVersion = UserDefaults.standard.string(forKey: "previousVersion") ?? "0.0.0"
    let didPresentCurrentOnboarding = UserDefaults.standard.bool(forKey: "didPresentCurrentOnboarding")
}

struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
    let tag: Int
    let description: String
    let moreDetails: String?
    let icon: String
    let options: [OnboardingItemOption]?
    let versionIntroduced: String
}

struct OnboardingItemOption: Identifiable {
    let id = UUID()
    let text: String
    let tag: Int
    let val: Any
}

enum PrivacyChoice: CaseIterable, Identifiable {
    var id: Self { self }
    case disable, icloud, mongodb
}

// TODO: Convert plain-text into Markdown and render it as such
// TODO: Add better visual examples in dialogue for privacy options
// MARK: Extract moreDetails to another array for simplicity?

private let onboardingFlow =
    [
        OnboardingItem(title: "Welcome", tag: 1, description: "It's great having you here on Shaker! Let's get some things set up first.", moreDetails: nil, icon: "figure.wave", options: nil, versionIntroduced: "0.0.1"),
        OnboardingItem(title: "Privacy", tag: 2, description: "Your privacy is my biggest concern: it's up to you to decide who I should share your data with.", moreDetails: "Blurb here about privacy, and the risks of data sync.", icon: "exclamationmark.lock.fill", options:
                        [
                            OnboardingItemOption(text: "Disable Sync", tag: 1, val: PrivacyChoice.disable),
                            OnboardingItemOption(text: "Enable iCloud-Only Sync", tag: 2, val: PrivacyChoice.icloud),
                            OnboardingItemOption(text: "Enable Atlas Sync", tag: 3, val: PrivacyChoice.mongodb)
                        ], versionIntroduced: "0.1.0"),
        OnboardingItem(title: "That's it!", tag: 3, description: "Thanks for using Shaker! Stay tuned for new updates", moreDetails: nil, icon: "flag.checkered.2.crossed", options: nil, versionIntroduced: "0.0.1")
    ]

func filterOnboardingData() -> [OnboardingItem]? {
    return onboardingFlow.filter { $0.versionIntroduced >= OnboardingInfo().previousVersion && !OnboardingInfo().didPresentCurrentOnboarding }
}
