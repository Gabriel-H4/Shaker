//
//  ObjectModels.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 3/1/23.
//

import Foundation
import RealmSwift

enum AuthKeyType: String, PersistableEnum {
    case base
    case appkey
    case webkey
    case mfa
}

enum SSOProvider: String, PersistableEnum {
    case none
    case apple
    case facebook
    case google
    case other
}

class AuthKeyURLs: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var url: String = ""
    
    convenience init(url: String) {
        self.init()
        self.url = url
    }
}

class AuthKeySSOProviders: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var provider: SSOProvider
    
    convenience init(sso: SSOProvider) {
        self.init()
        self.provider = sso
    }
}

class AuthKey: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String = ""
    @Persisted var username: String?
    @Persisted var token: String?
    @Persisted var type: AuthKeyType
    @Persisted var isFavorite: Bool = false

    let urls = List<AuthKeyURLs>()
    let linkedProviders = List<AuthKeySSOProviders>()
    
    // TODO: create a base init() {} so convenience inits() {} have a parent?
    
    // Initialize a new AppKey (no urls)
    convenience init(title: String, username: String, password: String, favorite: Bool) {
        self.init()
        self.title = title
        self.username = username
        self.token = password
        self.isFavorite = favorite
        self.type = .appkey
    }
    
    // Initialize a new WebKey (with urls)
    convenience init(title: String, username: String, password: String, urls: [String], favorite: Bool) {
        self.init()
        self.title = title
        self.username = username
        self.token = password
        self.isFavorite = favorite
        self.type = .webkey
        for url in urls {
            self.urls.append(AuthKeyURLs(url: url))
        }
    }
}
