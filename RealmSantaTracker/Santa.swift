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
    
    // MARK: - KVO
    
    // We'll need to save these, or notifications won't be sent
    private var observerTokens = [NSObject: NotificationToken]()
    
    func addObserver(_ observer: NSObject) {
        // Add a typical KVO observer to all the properties
        // One of these needs to generate the initial call, could be any of them
        addObserver(observer, forKeyPath: #keyPath(Santa._currentLocation), options: .initial, context: nil)
        // Want to make sure we're observing the location's properties in case someone changes one manually
        addObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.latitude), options: [], context: nil)
        addObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.longitude), options: [], context: nil)
        
        addObserver(observer, forKeyPath: #keyPath(Santa._activity), options: [], context: nil)
        addObserver(observer, forKeyPath: #keyPath(Santa.presentsRemaining), options: [], context: nil)
        
        observerTokens[observer] = route.addNotificationBlock {
            // self owns this route, so it will always outlive this closure
            [unowned self, weak observer] changes in
            switch changes {
            case .initial:
                // Fake a KVO call, just to keep things simple
                observer?.observeValue(forKeyPath: "route", of: self, change: nil, context: nil)
            case .update:
                observer?.observeValue(forKeyPath: "route", of: self, change: nil, context: nil)
            case .error:
                fatalError("Couldn't update Santa's info")
            }
        }
    }
    
    func removeObserver(_ observer: NSObject) {
        observerTokens[observer]?.stop()
        observerTokens.removeValue(forKey: observer)
        removeObserver(observer, forKeyPath: #keyPath(Santa._currentLocation))
        removeObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.latitude))
        removeObserver(observer, forKeyPath: #keyPath(Santa._currentLocation.longitude))
        removeObserver(observer, forKeyPath: #keyPath(Santa._activity))
        removeObserver(observer, forKeyPath: #keyPath(Santa.presentsRemaining))
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
