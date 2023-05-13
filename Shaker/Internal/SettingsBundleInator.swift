//
//  SettingsBundleManager.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/1/23.
//

import Foundation
class SettingsBundleInator {
    
    class func setVersionNumber() {
        LoggingInator.log(.setup, .function, .info, "Began updating the settings bundle version")
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set("\(version) (\(build))", forKey: "prefs_appVersion")
        LoggingInator.log(.setup, .function, .info, "Finished updating the settings bundle version to reflect the current app version")
    }
    
    class func reviewOnboarding() {
        LoggingInator.log(.setup, .function, .info, "Began evaluating app onboarding")
        checkAndSetOnboarding()
        if OnboardingInfo().currentVersion > OnboardingInfo().previousVersion {
            UserDefaults.standard.set(false, forKey: "didPresentCurrentOnboarding")
            LoggingInator.log(.setup, .function, .info, "The app onboarding was updated, last presented version \(OnboardingInfo().previousVersion), and the new version is \(OnboardingInfo().currentVersion)")
        }
        LoggingInator.log(.setup, .function, .info, "Finished evaluating app onboarding")
    }
    
    class func checkAndSetOnboarding() {
        LoggingInator.log(.setup, .function, .info, "Began checking for app onboarding reset")
        if UserDefaults.standard.bool(forKey: "prefs_onboarding") {
            UserDefaults.standard.set(false, forKey: "prefs_onboarding")
            UserDefaults.standard.set("0.0.0", forKey: "previousVersion")
            UserDefaults.standard.set(false, forKey: "didPresentCurrentOnboarding")
            LoggingInator.log(.setup, .function, .info, "User requested to restart app onboarding, the relevant keys were adjusted")
        }
        LoggingInator.log(.setup, .function, .info, "Finished checking for app onboarding reset")
    }
}
