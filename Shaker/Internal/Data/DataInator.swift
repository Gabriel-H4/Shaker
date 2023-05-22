//
//  DataInator.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/10/23.
//

import CoreData
import Foundation

@available(*, deprecated)
enum CredType: String {
    case password = "Password"
    case mfa = "2FA Key"
    case sso = "SSO Reference"
    case credential = "Other"
}

@available(*, deprecated, renamed: "ContainerInator.shared")
final class DataInator: ObservableObject {
    let container = NSPersistentCloudKitContainer(name: "AuthKey")
    
    init() {
        LoggingInator.log(.setup, .function, .info, "Began initializing CoreData Persistant Container")
        container.loadPersistentStores { description, error in
            if let error = error {
                LoggingInator.log(.setup, .function, .error, "Initializing the CoreData Persistant Container failed with error: \(error.localizedDescription)")
                fatalError("Initializing the CoreData Persistant Container failed with error: \(error.localizedDescription)")
            }
        }
        LoggingInator.log(.setup, .function, .info, "Finished initializing CoreData Persistant Container")
    }
}
