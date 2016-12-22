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
    
    func dataFilePath () -> String {
        let docsURLs = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        var dataURL = docsURLs[0]
        dataURL.appendPathComponent("spotdata")
        return dataURL.path
    }
    
    func populateBlocSpotData ()  {
        
        if FileManager.default.fileExists(atPath: self.dataFilePath()) {
            if let spots = NSKeyedUnarchiver.unarchiveObject(withFile: self.dataFilePath()) as? [PointOfInterest] {
                bls_points = spots
                print ("Unarchived %d spots", spots.count)
                
            } else
            {
                print ("Could not unarchive");
            }
        
        } else {
            populateWithStaticDefaults()
            
        }

    }
    
    func saveBlocSpotData ()  {
        
        let fp = self.dataFilePath()
        let success = NSKeyedArchiver.archiveRootObject(bls_points, toFile: fp)
        
        print("saveBlocSpotData %b", success)
        
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
            
            let handler : MKLocalSearchCompletionHandler = {
                (response, err) -> Void in
                
                print("In search completion handler");
                
                print("Found \(response?.mapItems.count) map items");
                
                if let items = response?.mapItems {
                    
                    // make a new point of interest and save it with the search term as description
                    
                    let poi = PointOfInterest();
                    poi.bls_placemark = items[0].placemark
                    poi.bls_name = searchTerm
                    poi.bls_note = default_titles[default_terms.index(of: dt)!]
                    
                    BLSDataSource.sharedInstance.bls_points.append(poi);
                    BLSDataSource.sharedInstance.saveBlocSpotData();
                }
            }
            
            localSearch.start(completionHandler:handler)
            
        }
        
    }
    
    
}
