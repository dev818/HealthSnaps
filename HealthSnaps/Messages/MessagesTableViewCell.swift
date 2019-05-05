//
//  MessagesTableViewCell.swift
//  HealthSnaps
//
//  Created by Admin on 21/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var statusTime: UILabel!
    @IBOutlet weak var statusImg: UIImageView!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


