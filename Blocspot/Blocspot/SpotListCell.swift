//
//  SpotListCell.swift
//  Blocspot
//
//  Created by Luke Everett on 5/18/16.
//  Copyright © 2016 ozzieozumo. All rights reserved.
//

import UIKit

protocol SpotListCellDelegate {
    
    func didTapDetail(row: Int)
}

class SpotListCell: UITableViewCell {
    
    // MARK: Properties
    
    var delegate : SpotListCellDelegate?
    var spotIndex : Int = 0 
    @IBOutlet weak var SpotStatusImage: UIImageView!
    @IBOutlet weak var SpotTitle: UILabel!
    @IBOutlet weak var SpotDetailLink: UIImageView!
    @IBOutlet weak var SpotDistanceIndicator: UILabel!
    @IBOutlet weak var SpotNote: UILabel!
    
    
    @IBOutlet weak var detailButton: UIButton!
       
}
