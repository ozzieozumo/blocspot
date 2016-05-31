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
    
    private init() {
        bls_points = [];
    }
    
    func initWithStaticDefaults ()
    
    {
        // instantiate a search manager and search for some nearby locations
        
        let default_terms = ["Chevy Chase Supermarket",
                             "3591 Hamlet PL",
                             "Downtown Silver Spring",
                             "Rosemary Hills Elementary School",
                             "Apple Store Bethesda Ave"];
        
            
        for dt in default_terms {
            
            let searchRequest = MKLocalSearchRequest();
            let searchTerm = dt;
            
            searchRequest.naturalLanguageQuery = searchTerm;
            
            
            let localSearch = MKLocalSearch(request: searchRequest);
            
            
            localSearch.startWithCompletionHandler {
                (response: MKLocalSearchResponse?, error: NSError?) in
                
                print("In search completion handler");
                
                print("Found \(response?.mapItems.count) map items");
                
                if let items = response?.mapItems {
                    
                    // make a new point of interest and save it with the search term as description
                    
                    let poi = PointOfInterest(descr: searchTerm, place: items[0].placemark);
                    
                    BLSDataSource.sharedInstance.bls_points.append(poi);
                    
                    
                }
            }

            
        }
        
    }
    
    
}