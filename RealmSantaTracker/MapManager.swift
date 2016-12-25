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
    private let mapView: MKMapView
    private let santaAnnotation = MKPointAnnotation()
    private var routeOverlay: MKPolyline
    
    init(mapView: MKMapView) {
        self.mapView = mapView
        santaAnnotation.title = "🎅"
        routeOverlay = MKPolyline(coordinates: [], count: 0)
        super.init()
        mapView.addAnnotation(self.santaAnnotation)
        self.mapView.delegate = self
    }
    
    func update(with santa: Santa) {
        // Update the map to show Santa's new location
        let santaLocation = santa.currentLocation.clLocationCoordinate2D
        let coordinates: [CLLocationCoordinate2D] = santa.route.flatMap { $0.location?.clLocationCoordinate2D }
        DispatchQueue.main.async {
            self.santaAnnotation.coordinate = santaLocation
            self.mapView.remove(self.routeOverlay)
            self.routeOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.add(self.routeOverlay)
        }
    }
}

extension MapManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard overlay is MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .black
        renderer.lineWidth = 3
        renderer.lineDashPattern = [3, 6]
        return renderer
    }
}

private extension Location {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
