//
//  PatientListTableViewCell.swift
//  HealthSnaps
//
//  Created by Admin on 29/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class PatientListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!    
    @IBOutlet weak var dividerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
