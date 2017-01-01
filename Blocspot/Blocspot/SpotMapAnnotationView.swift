//
//  SpotListAnnotationView.swift
//  Blocspot
//
//  Created by Luke Everett on 12/27/16.
//  Copyright © 2016 ozzieozumo. All rights reserved.
//

import UIKit
import MapKit

class SpotMapAnnotationView: MKPinAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    init(poi: PointOfInterest) {
        
        super.init(annotation: poi.bls_placemark, reuseIdentifier: "blspins")
        
        // create the callout view to show info from the point of interest
        
        self.detailCalloutAccessoryView = calloutView(poi: poi)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func calloutView(poi: PointOfInterest) -> UIView? {
        let callout = UIView()
        
        let name = UILabel()
        let note = UILabel()
        
        name.text = poi.bls_name
        note.text = poi.bls_note
        
        callout.addSubview(name)
        callout.addSubview(note)
        
        return callout
    }
    
}
