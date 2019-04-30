//
//  LiftCell.swift
//  Swollmeights
//
//  Created by Matthew Reid on 1/13/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit

class LiftCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel : UILabel!
    
    @IBOutlet weak var selectionIndicator: UIView!
    @IBOutlet weak var topIndicator: UIView!
    @IBOutlet weak var rightIndicator: UIView!
    @IBOutlet weak var leftIndicator: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()

       // self.layer.borderWidth = 4
        //self.selectionIndicator.layer.cornerRadius = 4.0
        
        //self.layer.borderColor = UIColor.init(red: 71/255, green: 72/255, blue: 72/255, alpha: 0.2).cgColor
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = false
        //self.layer.backgroundColor = UIColor.init(red: 71/255, green: 72/255, blue: 72/255, alpha: 0.1).cgColor
        self.alpha = 1.0
    }
    
}
