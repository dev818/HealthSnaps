//
//  NewChatTableViewCell.swift
//  HealthSnaps
//
//  Created by Admin on 22/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class NewChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
