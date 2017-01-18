//
//  SpotCategoryAddVCViewController.swift
//  Blocspot
//
//  Created by Luke Everett on 1/10/17.
//  Copyright © 2017 ozzieozumo. All rights reserved.
//

import UIKit

class SpotCategoryAddViewController: UIViewController {

 
       override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

   @IBOutlet weak var newcatName: UITextField!
    
    @IBAction func cancelAdd(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "exitAddCategory", sender: sender)
    }
   @IBAction func addCategory(_ sender: AnyObject) {
        
        // if name is empty, just cancel
        
        // add the new name, unless it exists already
        
        var cats = BLSDataSource.sharedInstance.bls_cats
        
        if !(cats.contains(where: {$0.title! == newcatName.text!})) {
            
            let newCat = Category()
            
            newCat.title = newcatName.text!
            newCat.pois = []
            newCat.color = BLSDataSource.sharedInstance.nextCategoryColor()
            
            cats.append(newCat)
            BLSDataSource.sharedInstance.bls_cats = cats
            BLSDataSource.sharedInstance.saveBlocSpotData()
            
            // now trigger an unwind segue
            
            self.performSegue(withIdentifier: "exitAddCategory", sender: sender)
            
        } else {
            
            let alertController = UIAlertController(title: "Cannot Add", message: "This category already exists", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                print("You pressed OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    @IBAction func nameEditingDidEnd(_ sender: AnyObject) {
    
        // don't need to do anything here
    
    }
 
}

