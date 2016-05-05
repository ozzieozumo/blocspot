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
    var bls_description :String?
    
    init(descr: String, place: MKPlacemark) {
        super.init(placemark: place);
        self.bls_description = descr;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}