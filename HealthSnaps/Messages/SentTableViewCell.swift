//
//  SentTableViewCell.swift
//  HealthSnaps
//
//  Created by Admin on 24/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class SentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senterName: UILabel!
    @IBOutlet weak var sentMessageLabel: UILabel!
    @IBOutlet weak var messageBackground: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageBackground.layer.cornerRadius = 10
        senterName.textColor = UIColor(hexString: "#2980b9")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
