//
//  DataViewController.swift
//  Blocspot
//
//  Created by Luke Everett on 4/19/16.
//  Copyright © 2016 ozziozumo. All rights reserved.
//

import UIKit

class SpotDetailViewController: UIViewController {

    
    // spotIndex will be set by prepare segue of the origin view 
    var spotIndex: Int = 0
    var spot: PointOfInterest?
    @IBOutlet weak var spotName: UITextField!
    @IBOutlet weak var spotNote: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        spot = BLSDataSource.sharedInstance.bls_points[self.spotIndex]
        self.spotName.text = spot!.bls_name
        self.spotNote.text = spot!.bls_note
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // setup labels for the spot
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        BLSDataSource.sharedInstance.bls_points[self.spotIndex] = spot!
    }

    @IBAction func spotNameEditingDidEnd(_ sender: AnyObject) {
        
        self.spot?.bls_name = self.spotName.text
    }
    @IBAction func spotNoteEditingDidEnd(_ sender: AnyObject) {
            
        self.spot?.bls_note = self.spotNote.text
    }
    
}

