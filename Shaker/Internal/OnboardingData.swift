//
//  OnboardingData.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/3/23.
//

import Foundation
import SwiftUI

struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
    let tag: Int
    let description: String
    let moreDetails: String?
    let icon: String
    let options: [OnboardingItemOption]?
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

let onboardingFlow =
    [
        OnboardingItem(title: "Welcome", tag: 1, description: "It's great having you here on Shaker! Let's get some things set up first.", moreDetails: nil, icon: "figure.wave", options: nil),
        OnboardingItem(title: "Privacy", tag: 2, description: "Your privacy is my biggest concern: it's up to you to decide who I should share your data with.", moreDetails: "{UNFINISHED + NOT REFLECTIVE OF CURRENT ENCRYPTION STATUS} When you save data to Shaker, like a password, it is only kept on this device. To sync all of your saved passwords between devices, that data must be sent to a server. Syncing only with iCloud allows you to access those passwords on your other Apple devices, when signed in with the same Apple ID. This can be more safe than the next option, because it's encrypted twice: once by Shaker, and then again by your device before it's sent to iCloud, where that second \"layer\" can only be decrypted by one of your devices. The first layer can only be decrypted by Shaker, once you authenticate yourself in the app. The final option for syncing data is with MongoDB's Atlas Device Sync. This option relies on MongoDB, a well-established company, to also keep your data safe. While it also is encrypted using that first \"layer\" on your device, it is not (yet) encrypted in MongoDB's Atlas. This introduces a serious concern: if a hacker attacks MongoDB, they could access your data. However, this allows for you to sync data between platforms: iOS and Android for example, while also supporting the same destinations as iCloud-only syncing.", icon: "exclamationmark.lock.fill", options:
                        [
                            OnboardingItemOption(text: "Disable Sync", tag: 1, val: PrivacyChoice.disable),
                            OnboardingItemOption(text: "Enable iCloud-Only Sync", tag: 2, val: PrivacyChoice.icloud),
                            OnboardingItemOption(text: "Enable Atlas Sync", tag: 3, val: PrivacyChoice.mongodb)
                        ]),
        OnboardingItem(title: "That's it!", tag: 3, description: "Thanks for using Shaker! Stay tuned for new updates", moreDetails: nil, icon: "flag.checkered.2.crossed", options: nil)
    ]
