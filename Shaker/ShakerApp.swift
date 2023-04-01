//
//  ShakerApp.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/1/23.
//

import SwiftUI

@main
struct ShakerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(RealmManager())
                .onAppear(perform: SettingsBundleManager.setVersionNumber)
        }
    }
}
