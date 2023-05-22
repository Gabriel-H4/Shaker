//
//  CloudKitManager.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/9/23.
//

import Foundation
import CloudKit

struct CloudKitManager {
    static let container = CKContainer(identifier: "iCloud.dev.peppr.shaker.test")
    
    static func evalAccountStatus() {
        LoggingInator.log(.runtime, .function, .info, "Began evaluating user account status for CloudKit Container")
        container.accountStatus { status, error in
            if let error = error {
                LoggingInator.log(.runtime, .function, .error, "There was an error evaluating the account status, the user's status is: \(status.rawValue) and the error is: \(error.localizedDescription)")
                print("A USER ERROR OCCURED WITH CLOUDKIT: \(error)")
            }
        }
        LoggingInator.log(.runtime, .function, .info, "Finished evaluating user account status for CloudKit Container")
    }
    
//    static func fetchData() {
//        container.privateCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: "file")) { record, error in
//
//        }
//    }
    
//    static func writeData() {
//        let record = CKRecord(recordType: "Realm")
//
//        container.privateCloudDatabase.save(record) { record, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            else {
//                print("Saved successfully!")
//            }
//        }
//    }
}
