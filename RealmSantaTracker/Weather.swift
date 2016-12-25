//
//  Weather.swift
//  RealmSantaTracker
//
//  Created by Keita Ito on 12/24/16.
//  Copyright © 2016 Keita Ito. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object {
    dynamic var location: Location?
    dynamic var lastUpdatedDate: Date = Date()
    
    private dynamic var _loadingStatus: Int = 0
    private dynamic var _temperature: Double = .nan
    private dynamic var _condition: Int = 0
    var loadingStatus: LoadingStatus {
        let condition = Condition(rawValue: _condition)!
        return LoadingStatus(serverStatus: _loadingStatus,
                             temperature: _temperature,
                             condition: condition)
        
    }
    
    convenience init(location: Location) {
        self.init()
        self.location = location
    }
    
    func addObserver(_ observer: NSObject) {
        addObserver(observer, forKeyPath: #keyPath(Weather._loadingStatus), options: .initial, context: nil)
    }
    
    func removeObserver(_ observer: NSObject) {
        removeObserver(observer, forKeyPath: #keyPath(Weather._loadingStatus))
    }
}

extension Weather {
    enum LoadingStatus {
        case uploading
        case processing
        case complete(temperature: Double, condition: Condition)
        
        fileprivate init(serverStatus: Int, temperature: Double, condition: Condition) {
            switch serverStatus {
            case 0:
                self = .uploading
            case 1:
                self = .processing
            case 2:
                self = .complete(temperature: temperature, condition: condition)
            default:
                fatalError("Unknown loading status: \(serverStatus)")
            }
        }
    }
}

extension Weather {
    enum Condition: Int {
        case unknown = 0
        case clearDay, clearNight, rain, snow, sleet, wind, fog, cloudy, partlyCloudyDay, partlyCloudyNight
    }
}

