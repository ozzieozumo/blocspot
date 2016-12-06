//
//  SpotListViewController.swift
//  Blocspot
//
//  Created by Luke Everett on 5/18/16.
//  Copyright © 2016 ozzieozumo. All rights reserved.
//

import UIKit
import CoreLocation

class SpotListViewController: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        
    }
    
    
    func distanceDisplayText (distanceMeters : CLLocationDistance) -> String {
    
        let distanceMiles = distanceMeters / 1609.344
        
        if distanceMiles < 0.1 {
            return "< 0.1 mi"
        }
        
        if distanceMiles < 1.0 {
            return "< 1.0 mi"
        }
        
        if (distanceMiles >= 1.0 && distanceMiles <= 100.0) {
            return String(format: "%.1f mi", distanceMiles)
        }
        else {
            return "> 100 mi"
        }
    }
    // MARK - Table View Data Source Delegate
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5;
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotListCell", for: indexPath) as! SpotListCell
        
        let spot = BLSDataSource.sharedInstance.bls_points[(indexPath as NSIndexPath).row]
        
        cell.SpotTitle.text = spot.bls_name;
        cell.SpotNote.text = spot.bls_note;
        if let distance = spot.bls_distance {
            cell.SpotDistanceIndicator.text = distanceDisplayText(distanceMeters: distance)
        } else {
            cell.SpotDistanceIndicator.text = "?";
        }
        
        
        
        return cell
        
    }
    
    func itemSelected(_ item:AnyObject) {
        //create segue
       
    }
    
    @IBAction func exitSegueHandler(_ segue:UIStoryboardSegue) {
    
    }
    
    
    
    // Mark - LocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // handle the denied error
        
        // keep trying in the event of other errors

        NSLog("Error from location manager %@", error.localizedDescription);
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // recompute distances for all of the saved spots
        
        for spot in BLSDataSource.sharedInstance.bls_points {
            
            let spotloc = spot.bls_placemark?.location!
            spot.bls_distance = spotloc?.distance(from: locations[0])
            
        }
        
        self.tableView.reloadData()
    }
    
    
    
    

}
