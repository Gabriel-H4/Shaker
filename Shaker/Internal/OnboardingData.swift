//
//  OnboardingData.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/3/23.
//

// TODO: Rewrite all of this :)

import Foundation
import SwiftUI

/// The onboarding information stored in UserDefaults
struct OnboardingInfo {
    static let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let previousVersion = UserDefaults.standard.string(forKey: "previousVersion") ?? "0.0.0"
    static let didPresentCurrentOnboarding = UserDefaults.standard.bool(forKey: "didPresentCurrentOnboarding")
}

/// An app onboarding item, with all data needed to form a view
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

/// An app onboarding item option, selectable using a picker
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
// MARK: Extract moreDetails to another array?

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

/// Check the OnboardingItems and filter it based on their versionIntroduced value
/// - Returns: All OnboardingItems where their versionIntroduced is greater than or equal to the previously installed app version
func filterOnboardingData() -> [OnboardingItem]? {
    LoggingInator.log(.runtime, .function, .info, "Filtered app onboarding cards to present")
    return onboardingFlow.filter { $0.versionIntroduced >= OnboardingInfo.previousVersion && !OnboardingInfo.didPresentCurrentOnboarding }
}
