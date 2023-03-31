//
//  RealmManager.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/2/23.
//

import Foundation
import RealmSwift


class RealmManager: ObservableObject {
    
    private enum ShakerRealmErrors: Error  {
        case thawError
    }
    
    private(set) var localRealm: Realm?
    @Published var savedKeys: [AuthKey] = []
    
    // When class is initialized, open a Realm using the specified config and fetch the items within it
    init() {
        openRealm()
        fetchAuthKeys()
    }
    
    func openRealm() {
        do {
            // Set encryptionKey: Data
            let config = Realm.Configuration(readOnly: false,
                                             schemaVersion: 1,
                                             deleteRealmIfMigrationNeeded: true)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
            print("STREXCORP: \(config.fileURL?.absoluteURL ?? URL(string: "")!)")
        }
        catch {
            print("Fatal error occured while opening the Realm: \(error.localizedDescription)")
        }
    }
    
    func fetchAuthKeys() {
        if let localRealm = localRealm {
            // Create temp array, to allow for filtering/sorting/etc
            let allAuthKeys = localRealm.objects(AuthKey.self)
            // Reset the array for state objects
            savedKeys = []
            allAuthKeys.forEach { savedKey in
                savedKeys.append(savedKey)
            }
        }
    }
    
    func toggleAuthKeyFavoriteStatus(key: AuthKey) {
        do {
            guard let thawed = key.thaw(), let realm = thawed.realm else {
                print("Failed thawing the key and/or realm")
                throw ShakerRealmErrors.thawError
            }
            try realm.write {
                thawed.isFavorite.toggle()
            }
            fetchAuthKeys()
            print("Set key at id \(thawed._id) to isFavorite: \(thawed.isFavorite) successfully!")
        }
        catch {
            print("There was an error toggling the AuthKey favorite property with ID: \(key._id), and error: \(error)")
        }
    }
}
