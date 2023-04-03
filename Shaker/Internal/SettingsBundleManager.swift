//
//  SettingsBundleManager.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/1/23.
//

import Foundation
class SettingsBundleManager {
    class func setVersionNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set("\(version) (\(build))", forKey: "prefs_appVersion")
    }
    
}
