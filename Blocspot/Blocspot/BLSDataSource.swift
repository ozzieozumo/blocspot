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
    var bls_cats: [Category];
    
    var bls_points : [PointOfInterest] {
        get {
            return bls_CategoryFilters.count > 0 ? bls_FilteredPoints : bls_AllPoints
            }
        }
    private var bls_AllPoints : [PointOfInterest]     // all points from the data source
    private var bls_FilteredPoints: [PointOfInterest] // only the points selected by the filter
    private var bls_FilterMap : [Int]                 // for each filtered point, maps to the index of the unfiltered array
    private var bls_CategoryFilters : [String]        // category names to filter by
    
    let standard_colors = [UIColor(hex: 0x395662),
                           UIColor(hex: 0x2A9D8F),
                           UIColor(hex: 0xE9C46A),
                           UIColor(hex: 0xF4A261),
                           UIColor(hex: 0xE76F51) ]
    
        
    fileprivate init() {
        bls_AllPoints = [];
        bls_CategoryFilters = [];
        bls_FilteredPoints = [];
        bls_FilterMap = []
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
                bls_AllPoints = all_data["points"] as! [PointOfInterest]
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
        let all_data: [String:Any] = ["points": bls_AllPoints, "categories": bls_cats]
        let success = NSKeyedArchiver.archiveRootObject(all_data, toFile: fp)
        
        print("saveBlocSpotData %b", success)
        
    }

    func pointAtIndex(_ i:Int) -> PointOfInterest {
        
        // if a filter is active, return a point from the filtered list, otherwise from the all points list
        
        if (bls_CategoryFilters.count > 0) {
            return bls_FilteredPoints[i]
        } else {
            return bls_AllPoints[i]
        }
    }
    
    func findPoint(byName name:String) -> Int? {
        
        // finds the index of the first point matching the given title
        // if filtering is active, the index is relative to the filtered view
        // if no match, then nil is returned
        
        for (index, poi) in bls_points.enumerated(){
            if poi.bls_name == name {
                return index
            }
        }
        
        return nil
    }
    
    func setPointAtIndex(poi: PointOfInterest, index: Int) {
        
        if (bls_CategoryFilters.count > 0) {
            
            // if a category filter is active, update both arrays, translating the index
            
            bls_FilteredPoints[index] = poi
            bls_AllPoints[bls_FilterMap[index]] = poi
            
        } else {
            bls_AllPoints[index] = poi
        }
        
        self.saveBlocSpotData()
    }
    
    func deleteAtIndex(_ i: Int) {
        // If a category filter is active, delete from the unfiltered array AND the filtered array
        
        if (bls_CategoryFilters.count > 0) {
            bls_AllPoints.remove(at: bls_FilterMap[i])
            bls_FilteredPoints.remove(at: i)
            bls_FilterMap.remove(at: i)
        } else {
            bls_AllPoints.remove(at: i)
        }
        
        self.saveBlocSpotData()
    }
    
    func appendPoint(_ p: PointOfInterest) {
        
    // if a filter is active, add the point to the unfiltered array and the filtered array
    
        if (bls_CategoryFilters.count > 0) {
            bls_AllPoints.append(p)
            bls_FilteredPoints.append(p)
            bls_FilterMap.append(bls_AllPoints.count - 1)
        } else {
            bls_AllPoints.append(p)
        }
        
        self.saveBlocSpotData()
        
    }
    
    func applyCategoryFilters(filters: [String]) {
        
        // create a filtered version of the points array, saving the original index
        
        bls_CategoryFilters  = filters  // overwrite any existing filters
        bls_FilteredPoints = []                 // reset the filtered list
        bls_FilterMap = []                      // reset the filter map

       
        for (index, poi) in bls_AllPoints.enumerated() {
        
            if let title = poi.bls_category?.title {
            
                if bls_CategoryFilters.contains(title) {
                    bls_FilteredPoints.append(poi)
                    bls_FilterMap.append(index)
                }
            }
        }
    
    }
    
    func clearCategoryFilters() {

    // clear the filter list and discard the duplicate array
    
        bls_CategoryFilters = [];
        bls_FilteredPoints = [];
        bls_FilterMap = [];
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
                    
                    BLSDataSource.sharedInstance.appendPoint(poi);
                    BLSDataSource.sharedInstance.saveBlocSpotData();
                }
            }
            
            localSearch.start(completionHandler:handler)
            
        }
        
    }
    
    func nextCategoryColor() -> UIColor {
        
        return standard_colors[bls_cats.count % standard_colors.count]

    }
    
}

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}
