//
//  ReceivedTableViewCell.swift
//  HealthSnaps
//
//  Created by Admin on 24/11/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class ReceivedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var receivedTimeLabel: UILabel!
    @IBOutlet weak var messageBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        patientName.textColor = UIColor(hexString: "#e67e22")
        messageBackground.layer.cornerRadius = 10
        messageLabel.backgroundColor = UIColor(hexString: "#2980b9")
        messageBackground.backgroundColor = UIColor(hexString: "#2980b9")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



