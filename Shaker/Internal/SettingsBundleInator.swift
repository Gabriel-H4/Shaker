//
//  SettingsBundleManager.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/1/23.
//

import Foundation
class SettingsBundleInator {
    class func setVersionNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set("\(version) (\(build))", forKey: "prefs_appVersion")
    }
    
    class func reviewOnboarding() {
        checkAndSetOnboarding()
        if OnboardingInfo().currentVersion > OnboardingInfo().previousVersion {
            UserDefaults.standard.set(false, forKey: "didPresentCurrentOnboarding")
        }
    }
    
    class func checkAndSetOnboarding() {
        if UserDefaults.standard.bool(forKey: "prefs_onboarding") {
            UserDefaults.standard.set(false, forKey: "prefs_onboarding")
            UserDefaults.standard.set("0.0.0", forKey: "previousVersion")
            UserDefaults.standard.set(false, forKey: "didPresentCurrentOnboarding")
        }
    }
}
