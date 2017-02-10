//
//  SpotMapViewController.swift
//  Blocspot
//
//  Created by Luke Everett on 4/25/16.
//  Copyright © 2016 ozzieozumo. All rights reserved.
//

import UIKit
import MapKit

class SpotMapViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var txtSearchInput: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var defaultRegionSet: Bool = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        for poi in BLSDataSource.sharedInstance.bls_points {
        
            let annotation = SpotMapAnnotation(poi: poi)
            self.mapView.addAnnotation(annotation)
            
        
        }
        
        if !self.defaultRegionSet {
            
            // On the first time, set the map region to contain all of the annotations
            //self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
            // Set the default region to 1km around the first annotation
            
            if self.mapView.annotations.count > 0 {
                
                centerMapOnAnnotation(annotation: self.mapView.annotations[0], radiuskm: 1)
                
            }
            
            self.defaultRegionSet = true
        }
        
    }
    
    func centerMapOnAnnotation(annotation: MKAnnotation, radiuskm: Double) {
        
        // Center the map on one of its annotations, and zoom to a specified radius
        
        
        var region: MKCoordinateRegion;
        let lat: CLLocationDistance = radiuskm * 1000.0;
        let lng: CLLocationDistance = radiuskm * 1000.0;
        
        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, lat, lng)
        
        self.mapView.setRegion(region, animated: true)
        
        
    }
    
    func deleteCandidateAnnotations() {
        
        for annotation in self.mapView.annotations {
            if let sma = annotation as? SpotMapAnnotation {
                if sma.type == BlocSpotAnnotationType.Candidate {
                    self.mapView.removeAnnotation(sma)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField == txtSearchInput) {
            
            // delete any existing candidate spots
            
            self.deleteCandidateAnnotations()
            
            // create a search request
            print("Search string is \(textField.text!)");
            
        
            let searchRequest = MKLocalSearchRequest();
            let searchTerm = textField.text!;
            
            searchRequest.naturalLanguageQuery = searchTerm;
            
            // only search within the visible region of the map
            
            searchRequest.region = self.mapView.region;
            
            let localSearch = MKLocalSearch(request: searchRequest);
            
            
            localSearch.start {
                (response, error) -> Void in
                
                print("In search completion handler");
                
                print("Found \(response?.mapItems.count) map items");
                
                for item in response?.mapItems ?? [] {
                    
                    // make a new point of interest and save it with the search term as description
                    
                    let poi = PointOfInterest()
                    poi.bls_placemark = item.placemark
                    poi.bls_name = searchTerm
                    
                    let annotation = SpotMapAnnotation(poi: poi)
                    annotation.type = BlocSpotAnnotationType.Candidate
                    self.mapView.addAnnotation(annotation);
                    
                }
            };
            
            
            
            
        }
        return true;
    }
    
}

// MARK: MapView Delegate
extension SpotMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let sma = annotation as? SpotMapAnnotation {
            
            return SpotMapAnnotationView(annotation: sma, reuseIdentifier: "blspoints")
            
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Test which control was tapped and either save or delete the candidate spot
        
        if control.tag == 1  {
            //Candidate Discard
            
            mapView.removeAnnotation(view.annotation!)
            
        }
        
        if control.tag == 2 {
            // Candidate Save as Favorite
            // Convert to a favorite POI and save it in the data source
            
            
            
            let sma = (view.annotation) as! SpotMapAnnotation
            if let poi = sma.poi {
            
                BLSDataSource.sharedInstance.appendPoint(poi)
                BLSDataSource.sharedInstance.saveBlocSpotData()
                
                sma.type = BlocSpotAnnotationType.Favorite
                (view as! MKPinAnnotationView).pinTintColor = UIColor.green
                
                mapView.deselectAnnotation(sma, animated: true)
                
            }

            
            
        }
        
        if control.tag == 3 {
            
            // Favorite Navigate To (go to Maps App)
            
        }
        
        if control.tag == 4 {
            
            // Favorite to Spot Detail View
            // example of showing a view controller from another storyboard without using a segue
            
            let sma = (view.annotation) as! SpotMapAnnotation
            let title = sma.poi?.bls_name ?? ""

            if let index = BLSDataSource.sharedInstance.findPoint(byName: title) {
                
                
                let storyboard = UIStoryboard(name: "SpotList", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SpotDetailScene")
                let detailVC = controller as! SpotDetailViewController
                detailVC.spotIndex = index
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
            
        }
        
        
        
    
        
        
    }
    
}

