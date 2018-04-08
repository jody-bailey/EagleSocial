//
//  SelectFriendTableViewCell.swift
//  EagleSocial
//
//  Created by Michael Pearson on 4/7/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

class SelectFriendTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
