//
//  Category.swift
//  Blocspot
//
//  Created by Luke Everett on 5/17/16.
//  Copyright © 2016 ozzieozumo. All rights reserved.
//

import Foundation
import UIKit


class Category : NSObject, NSCoding {
    
    var title: String? = ""
    var color: UIColor = UIColor.orange;
    var pois: [PointOfInterest] = []
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        self.title = aDecoder.decodeObject(forKey: "cat_title") as? String
        self.color = aDecoder.decodeObject(forKey: "cat_color") as! UIColor
        self.pois  = aDecoder.decodeObject(forKey: "cat_pois")  as! [PointOfInterest]
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.title, forKey: "cat_title")
        aCoder.encode(self.color, forKey: "cat_color")
        aCoder.encode(self.pois, forKey: "cat_pois")
        
    }

    
}
