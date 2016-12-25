//
//  SantaTrackerViewController.swift
//  RealmSantaTracker
//
//  Created by Keita Ito on 12/24/16.
//  Copyright © 2016 Keita Ito. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class SantaTrackerViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var timeRemainingLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var activityLabel: UILabel!
    @IBOutlet private weak var temperratureLabel: UILabel!
    @IBOutlet private weak var presentRemainingLabel: UILabel!
    
    // MARK: - Properties
    
    // Has to be implicitly unwrapped
    // Needs the reference to the map view
    private var mapManager: MapManager!
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set up the map manager
        mapManager = MapManager(mapView: mapView)
        
        // Find the Santa data in Realm
        let realm = try! Realm()
        let santas = realm.objects(Santa.self)
        
        // Set up the test Santa if he's not already there
        if santas.isEmpty {
            try? realm.write {
                realm.add(Santa.test())
            }
        }
        
        // Be responsible in unwrapping!
        if let santa = santas.first {
            // Update the map
            mapManager.update(with: santa)
        }
    }
    
    private func update(with santa: Santa) {
        mapManager.update(with: santa)
        let activity = santa.activity.description
        let presentsRemaining = "\(santa.presentsRemaining)"
        DispatchQueue.main.async {
            self.activityLabel.text = activity
            self.presentRemainingLabel.text = presentsRemaining
        }
    }
}
