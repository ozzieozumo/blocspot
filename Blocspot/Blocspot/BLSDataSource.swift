//
//  BLSDataSource.swift
//  Blocspot
//
//  Created by Luke Everett on 5/1/16.
//  Copyright © 2016 ozzieozumo. All rights reserved.
//

import Foundation

class BLSDataSource {
    
    static let sharedInstance = BLSDataSource()
    var bls_points : [PointOfInterest];
    
    private init() {
        bls_points = [];
    }
    
    
    
}