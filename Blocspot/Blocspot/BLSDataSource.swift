//
//  BLSDataSource.swift
//  Blocspot
//
//  Created by Luke Everett on 5/1/16.
//  Copyright © 2016 ozzieozumo. All rights reserved.
//

import Foundation
import MapKit

class BLSDataSource {
    
    static let sharedInstance = BLSDataSource()
    var bls_points : [PointOfInterest];
    
    fileprivate init() {
        bls_points = [];
    }
    
    func populateWithStaticDefaults ()
    
    {
        // instantiate a search manager and search for some nearby locations
        
        let default_terms = ["Chevy Chase Supermarket",
                             "3591 Hamlet PL",
                             "Downtown Silver Spring",
                             "Rosemary Hills Elementary School",
                             "Apple Store Bethesda Ave"];
        
        let default_titles = ["Shops",
                              "Home",
                              "Work",
                              "School",
                              "MoneyPit"]
        
            
        for dt in default_terms {
            
            let searchRequest = MKLocalSearchRequest();
            let searchTerm = dt;
            
            searchRequest.naturalLanguageQuery = searchTerm;
            
            
            let localSearch = MKLocalSearch(request: searchRequest);
            
            
            
            /*
            localSearch.start {
                (response: MKLocalSearchResponse?, error: NSError?) in
                
                print("In search completion handler");
                
                print("Found \(response?.mapItems.count) map items");
                
                if let items = response?.mapItems {
                    
                    // make a new point of interest and save it with the search term as description
                    
                    let poi = PointOfInterest(descr: searchTerm, place: items[0].placemark);
                    poi.bls_note = default_titles[default_terms.index(of: dt)!]
                    
                    BLSDataSource.sharedInstance.bls_points.append(poi);
                    
                    
                }
            } as! MKLocalSearchCompletionHandler
 */
            
            let handler : MKLocalSearchCompletionHandler = {
                (response, err) -> Void in
                
                print("In search completion handler");
                
                print("Found \(response?.mapItems.count) map items");
                
                if let items = response?.mapItems {
                    
                    // make a new point of interest and save it with the search term as description
                    
                    let poi = PointOfInterest(descr: searchTerm, place: items[0].placemark);
                    poi.bls_note = default_titles[default_terms.index(of: dt)!]
                    
                    BLSDataSource.sharedInstance.bls_points.append(poi);
                }
            }
            
            localSearch.start(completionHandler:handler)
            
        }
        
    }
    
    
}
