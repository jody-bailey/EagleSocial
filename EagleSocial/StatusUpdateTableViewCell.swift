//
//  StatusUpdateTableViewCell.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/17/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase

class StatusUpdateTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        ref.child("feed/posts").setValue(statusTextField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
}
