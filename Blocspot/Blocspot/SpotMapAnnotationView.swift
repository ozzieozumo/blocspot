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
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.annotation = annotation
        self.canShowCallout = true
        
        // create the callout view to show info from the point of interest
        if let sma = annotation as? SpotMapAnnotation {
            
            self.detailCalloutAccessoryView = calloutView(poi: sma.poi!)
            
            switch sma.type {
            case .Favorite:
                self.pinTintColor = UIColor.green
                
            case .Candidate:
                self.pinTintColor = UIColor.yellow
                self.leftCalloutAccessoryView = candidateDiscardButton()
                self.rightCalloutAccessoryView = candidateSaveButton()
                
            }
            
        }
        
        
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func calloutView(poi: PointOfInterest) -> UIView {
        
        /* the standard callout will be created by mapview, this just creates the subview underneath the title
           I think it would be possible to create a more complicated view with subviews here, but the leable containing 
           the title will always be there (unless showCallOut is FALSE)
        */
 
        let note = UILabel()
        let labelstr: String = (poi.bls_note ?? "BLS Note")
        note.text = labelstr
        note.layer.borderWidth = 1.0;
        note.layer.borderColor = UIColor.orange.cgColor
        
        return note
    }
    
    func candidateDiscardButton() -> UIView {
        
        let btn = UIButton()
        btn.titleLabel?.text = "Lose It"
        
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = UIColor.yellow.cgColor
        
        return btn
    }
    
    func candidateSaveButton() -> UIView {
        
        let btn = UIButton()
        btn.titleLabel?.text = "Keep It"
        
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = UIColor.yellow.cgColor
        
        return btn
    }
    
}
