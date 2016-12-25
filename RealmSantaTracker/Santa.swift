//
//  Santa.swift
//  RealmSantaTracker
//
//  Created by Keita Ito on 12/24/16.
//  Copyright © 2016 Keita Ito. All rights reserved.
//

import Foundation
import RealmSwift

class Santa: Object {
    private dynamic var _currentLocation: Location?
    var currentLocation: Location {
        get {
            // If we don't know where Santa is, he's probably still at home
            // I hear GPS isn't great up there
            return _currentLocation ?? Location(latitude: 90, longitude: 180)
        }
        set {
            _currentLocation = newValue
        }
    }
    
    let route = List<Stop>()
    
    private dynamic var _activity: Int = 0
    var activity: Activity {
        get {
            return Activity(rawValue: _activity)!
        }
        set {
            _activity = newValue.rawValue
        }
    }
    
    dynamic var presentsRemaining: Int = 0
    
    override static func ignoredProperties() -> [String] {
        return ["currentLocation", "activity"]
    }
}

extension Santa {
    static func test() -> Santa {
        let santa = Santa()
        santa.currentLocation = Location(latitude: 37.7749, longitude: -122.4194)
        santa.activity = .deliveringPresents
        santa.presentsRemaining = 42
        return santa
    }
}
