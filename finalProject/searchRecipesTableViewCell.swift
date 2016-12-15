//
//  searchRecipesTableViewCell.swift
//  finalProject
//
//  Created by Femke van Son on 09-12-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit


class searchRecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeRate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
