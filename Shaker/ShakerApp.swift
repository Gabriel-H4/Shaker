//
//  ShakerApp.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/1/23.
//

import SwiftUI

@main
struct ShakerApp: App {

    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var dataInator = DataInator()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataInator.container.viewContext)
                .onAppear {
                    LoggingInator.log(.setup, .app, .info, "Shaker has been launched")
                    SettingsBundleInator.setVersionNumber()
                    SettingsBundleInator.reviewOnboarding()
                }
                .onChange(of: scenePhase) { newPhase in
                    LoggingInator.log(.runtime, .app, .info, "State change detected, new scenePhase is \(newPhase)")
                }
        }
    }
}
