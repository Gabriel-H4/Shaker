//
//  CloudKitManager.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 4/9/23.
//

import Foundation
import CloudKit

struct CloudKitManager {
    static let container = CKContainer(identifier: "iCloud.icloud.shaker.test")
    
    static func evalAccountStatus() {
        container.accountStatus { status, error in
            if let error = error {
                print("A USER ERROR OCCURED WITH CLOUDKIT: \(error)")
            }
        }
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
