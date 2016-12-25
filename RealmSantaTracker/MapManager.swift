//
//  MapManager.swift
//  RealmSantaTracker
//
//  Created by Keita Ito on 12/24/16.
//  Copyright © 2016 Keita Ito. All rights reserved.
//

import UIKit
import MapKit

class MapManager: NSObject {
    private let santaAnnotation = MKPointAnnotation()
    
    init(mapView: MKMapView) {
        santaAnnotation.title = "🎅"
        super.init()
        mapView.addAnnotation(self.santaAnnotation)
    }
    
    func update(with santa: Santa) {
        // Update the map to show Santa's new location
        let santaLocation = santa.currentLocation.clLocationCoordinate2D
        DispatchQueue.main.async {
            self.santaAnnotation.coordinate = santaLocation
        }
    }
}

private extension Location {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
