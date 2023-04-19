//
//  ShakerApp.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/1/23.
//

import SwiftUI

@main
struct ShakerApp: App {

    @StateObject private var dataInator = DataInator()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataInator.container.viewContext)
                .onAppear {
                    SettingsBundleInator.setVersionNumber()
                    SettingsBundleInator.reviewOnboarding()
                }
        }
    }
}
