//
//  MatchCell.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/20/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       self.imgView.frame.size.height = 90
       self.imgView.frame.size.width = 90
    }
    
}
