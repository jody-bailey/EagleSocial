//
//  CommentCell.swift
//  EagleSocial
//
//  Created by Jody Bailey on 3/17/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
