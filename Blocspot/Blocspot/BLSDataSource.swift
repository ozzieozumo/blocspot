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
    var bls_cats: [Category];
    
    let standard_colors = [UIColor.orange, UIColor.purple, UIColor.green, UIColor.yellow]
    
        
    fileprivate init() {
        bls_points = [];
        bls_cats = [];
    }
    
    func dataFilePath () -> String {
        let docsURLs = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        var dataURL = docsURLs[0]
        dataURL.appendPathComponent("spotdata")
        return dataURL.path
    }
    
    func populateBlocSpotData ()  {
        
        if FileManager.default.fileExists(atPath: self.dataFilePath()) {
            if let all_data = NSKeyedUnarchiver.unarchiveObject(withFile: self.dataFilePath()) as? [String:Any] {
                bls_points = all_data["points"] as! [PointOfInterest]
                bls_cats = all_data["categories"] as! [Category]
                print ("Unarchived %d spots", bls_points.count)
                
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
        let all_data: [String:Any] = ["points": bls_points, "categories": bls_cats]
        let success = NSKeyedArchiver.archiveRootObject(all_data, toFile: fp)
        
        print("saveBlocSpotData %b", success)
        
    }

    func deleteAtIndex(_ i: Int) {
        // Delete references from the categories then delete the point itself
        bls_points.remove(at: i)
        self.saveBlocSpotData()
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
        
        let default_categories = ["Restaurants",
                                  "Bars",
                                  "Stores",
                                  "Tourist Traps"]
        
        
        for (index, dc) in default_categories.enumerated() {
            let cat = Category()
            cat.title = dc
            cat.color = standard_colors[index % standard_colors.count]
            cat.pois = [];
            bls_cats.append(cat)
        }
        
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
