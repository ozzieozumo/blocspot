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
                self.leftCalloutAccessoryView = favoriteNavigateButton()
                self.rightCalloutAccessoryView = favoriteDetailButton()
                
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
        let labelstr: String = (poi.bls_note ?? "")
        note.text = labelstr
        //note.layer.borderWidth = 1.0;
        //note.layer.borderColor = UIColor.orange.cgColor
        
        return note
    }
    
    func candidateDiscardButton() -> UIView {
        
        let btn = UIButton()
        btn.tag = 1
        btn.setBackgroundImage(UIImage(named: "pushpin-7"), for: .normal)
        //btn.setTitle("Lose It", for: .normal)
        //btn.setTitleColor(UIColor.blue, for: .normal)
        btn.sizeToFit()
        
        
        
        return btn
    }
    
    func candidateSaveButton() -> UIView {
        
        let btn = UIButton()
        btn.tag = 2
        btn.setBackgroundImage(UIImage(named: "heart-7"), for: .normal)
        //btn.setTitle("Keep It", for: .normal)
        //btn.setTitleColor(UIColor.blue, for: .normal)
        btn.sizeToFit()
        
        return btn
    }
    
    func favoriteNavigateButton() -> UIView {
        
        let btn = UIButton()
        btn.tag = 3
        btn.setBackgroundImage(UIImage(named: "navigate"), for: .normal)
        //btn.setTitle("Lose It", for: .normal)
        //btn.setTitleColor(UIColor.blue, for: .normal)
        btn.sizeToFit()
        
        
        
        return btn
    }
    
    func favoriteDetailButton() -> UIView {
        
        let btn = UIButton()
        btn.tag = 4
        btn.setBackgroundImage(UIImage(named: "details"), for: .normal)
        //btn.setTitle("Keep It", for: .normal)
        //btn.setTitleColor(UIColor.blue, for: .normal)
        btn.sizeToFit()
        
        return btn
    }

    
}
