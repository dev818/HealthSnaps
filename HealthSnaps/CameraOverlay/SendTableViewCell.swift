//
//  SendTableViewCell.swift
//  HealthSnaps
//
//  Created by Admin on 05/12/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class SendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstSpellLabel: UILabel!
    @IBOutlet weak var patientName: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        firstSpellLabel.textColor = UIColor(hexString: "#2980b9")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
