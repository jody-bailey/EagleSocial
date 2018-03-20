//
//  MessageListTableCell.swift
//  EagleSocial
//
//  Created by Michael Pearson on 3/18/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

class MessageListTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
