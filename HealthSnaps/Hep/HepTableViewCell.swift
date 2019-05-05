//
//  HepTableViewCell.swift
//  HealthSnaps
//
//  Created by Admin on 27/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class HepTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseName: UILabel!    
    @IBOutlet weak var exerciseDesc: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
