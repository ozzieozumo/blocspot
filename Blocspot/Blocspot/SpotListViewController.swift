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
    
    // MARK - Data Source 
    
    
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
        
        
        return cell
        
    }
    
    func itemSelected(_ item:AnyObject) {
        //create segue
       
    }
    
    @IBAction func exitSegueHandler(_ segue:UIStoryboardSegue) {
    
    }
    
    
    // Mark - Delegate
    
    // Mark - LocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // handle the denied error
        
        // keep trying in the event of other errors
        
        NSLog("Error from location manager", error.localizedDescription);
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    

}
