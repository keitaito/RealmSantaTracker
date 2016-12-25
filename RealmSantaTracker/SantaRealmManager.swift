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
    func realm() -> Realm {
        return try! Realm()
    }
}
