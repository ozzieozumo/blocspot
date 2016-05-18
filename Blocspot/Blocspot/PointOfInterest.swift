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

class PointOfInterest : MKPlacemark {
    var bls_name :String?
    var bls_note :String?
    
    init(descr: String, place: MKPlacemark) {
        super.init(placemark: place);
        self.bls_name = descr;
        self.bls_note = "";
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}