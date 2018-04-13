//
//  AboutMeCell.swift
//  EagleSocial
//
//  Created by Lacy Simpson on 4/11/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AboutMeCell: UITableViewCell {
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var ref: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.descriptionLabel.sizeToFit()
        ref = Database.database().reference()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAboutMe()
    {
        self.descriptionLabel.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. "
    }
    
}
