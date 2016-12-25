//
//  SantaRealmManager.swift
//  RealmSantaTracker
//
//  Created by Keita Ito on 12/24/16.
//  Copyright © 2016 Keita Ito. All rights reserved.
//

import Foundation
import RealmSwift

class SantaRealmManager {
    // MARK: - Properties
    private let username = "santatracker@realm.io"
    private let password = "h0h0h0"
    
    private let authServerURL = URL(string: "http://162.243.150.99:9080")!
    private let santaRealmURL = URL(string: "realm://162.243.150.99:9080/santa")!
    private let weatherRealmURL = URL(string: "realm://162.243.150.99:9080/santa-weather")!
    
    private var user: SyncUser?
    
    // MARK: - Methods
    
    func logIn(completion: ((Void)->Void)? = nil) {
        guard user == nil else {
            completion?()
            return
        }
        
        let credentials = SyncCredentials.usernamePassword(username: username, password: password)
        SyncUser.logIn(with: credentials, server: authServerURL) {
            (user, error) in
            if let user = user {
                self.user = user
                DispatchQueue.main.async {
                    completion?()
                }
            } else if let error = error {
                fatalError("Could not log in: \(error)")
            }
        }
    }
    
    func santaRealm() -> Realm? {
        return realm(for: user, at: santaRealmURL)
    }
    
    func weatherRealm() -> Realm? {
        return realm(for: user, at: weatherRealmURL)
    }
    
    
    private func realm(for user: SyncUser?, at syncServerURL: URL) -> Realm? {
        guard let user = user else {
            return nil
        }
        
        let syncConfig = SyncConfiguration(user: user, realmURL: syncServerURL)
        let config = Realm.Configuration(syncConfiguration: syncConfig)
        guard let realm = try? Realm(configuration: config) else {
            fatalError("Could not load Realm")
        }
        return realm
    }
}
