//
//  RecepisListTableViewCell.swift
//  finalProject
//
//  Created by Femke van Son on 07-12-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit

class RecepisListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
