//
//  DataInator.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/10/23.
//

import CoreData
import Foundation

enum CredType: String {
    case password = "Password"
    case mfa = "2FA Key"
    case sso = "SSO Reference"
    case credential = "Other"
}

class DataInator: ObservableObject {
    let container = NSPersistentContainer(name: "AuthKey")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load the Container's Persistant Store with error: \(error.localizedDescription)")
            }
        }
    }
}
