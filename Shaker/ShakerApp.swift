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
    
    let authInator = AuthenticationInator.shared
    let containerInator = ContainerInator.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext,
                              AuthenticationInator.isSwiftPreview
                              ? ContainerInator.preview.container.viewContext
                              : containerInator.container.viewContext)
                .environmentObject(authInator)
                .onAppear {
                    LoggingInator.log(.setup, .app, .info, "Shaker has finished launching, and the WindowGroup is now presenting content")
                    SettingsBundleInator.setVersionNumber()
                    SettingsBundleInator.reviewOnboarding()
                    LoggingInator.log(.setup, .app, .info, "Finished all setup tasks")
                }
                .onChange(of: scenePhase) { newPhase in
                    LoggingInator.log(.runtime, .app, .info, "An app state change was detected, the new scenePhase is \(newPhase). Now saving the CoreData container.")
                    containerInator.save()
                }
        }
    }
}
