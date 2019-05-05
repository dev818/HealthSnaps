//
//  LibraryTableViewCell.swift
//  HealthSnaps
//
//  Created by Admin on 03/12/2017.
//  Copyright © 2017 getHealthSnaps. All rights reserved.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
