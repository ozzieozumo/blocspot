//
//  PointOfInterest.swift
//  Blocspot
//
//  Created by Luke Everett on 4/25/16.
//  Copyright © 2016 ozzieozumo. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class PointOfInterest : NSObject, NSCoding{
    var bls_placemark : MKPlacemark?
    var bls_name :String?
    var bls_note :String?
    var bls_distance :CLLocationDistance?
    weak var bls_category : Category?
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        self.bls_placemark = aDecoder.decodeObject(forKey: "placemark") as? MKPlacemark
        self.bls_note = aDecoder.decodeObject(forKey: "note") as! String?
        self.bls_distance = aDecoder.decodeObject(forKey: "distance") as! CLLocationDistance?
        self.bls_name = aDecoder.decodeObject(forKey: "name") as! String?
        self.bls_category = aDecoder.decodeObject(forKey: "category") as! Category?
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bls_placemark, forKey: "placemark")
        aCoder.encode(bls_name, forKey: "name")
        aCoder.encode(bls_note, forKey: "note")
        aCoder.encode(bls_distance, forKey: "distance")
        aCoder.encode(bls_category, forKey: "category")
    }
}
