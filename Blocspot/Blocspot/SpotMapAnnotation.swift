//
//  SpotMapAnnotation.swift
//  Blocspot
//
//  Created by Luke Everett on 12/31/16.
//  Copyright © 2016 ozzieozumo. All rights reserved.
//

import UIKit
import MapKit

enum BlocSpotAnnotationType {
    case Favorite   // saved spot
    case Candidate  // search result or similar candidate
}

class SpotMapAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var poi : PointOfInterest?
    var type: BlocSpotAnnotationType = BlocSpotAnnotationType.Favorite
    
    init (poi : PointOfInterest) {
        if let pm = poi.bls_placemark {
            self.coordinate = pm.coordinate
            self.title = poi.bls_name
            self.subtitle = poi.bls_note
            self.poi = poi
            
        }
    }
    
    
}
