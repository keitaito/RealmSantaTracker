//
//  Stop.swift
//  RealmSantaTracker
//
//  Created by Keita Ito on 12/24/16.
//  Copyright © 2016 Keita Ito. All rights reserved.
//

import Foundation
import RealmSwift

class Stop: Object {
    dynamic var location: Location?
    dynamic var time: Date = Date(timeIntervalSinceReferenceDate: 0)
    
    convenience init(location: Location, time: Date) {
        self.init()
        self.location = location
        self.time = time
    }
}
