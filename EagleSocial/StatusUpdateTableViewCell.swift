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
    
    var ref: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        ref = Database.database().reference()
        statusTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
//        let user = Auth.auth().currentUser?.uid
        
//        var user : User?
        
        if statusTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
//            let userID = Auth.auth().currentUser?.uid
//            ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                // ...
            let text = self.statusTextField.text
            
            let dateString = String(describing: Date())
            
            let parameters : [String : Any] =    ["user": thisUser.getName(),
                                                  "message": text!,
                                                  "date": dateString,
                                                  "userId": thisUser.userID,
                                                  "likes": []
                                                ] //= likes
                
                
                self.ref.child("posts").childByAutoId().setValue(parameters)
                self.statusTextField.text = ""
//            }) { (error) in
//                print(error.localizedDescription)
//            }
            
            statusTextField.resignFirstResponder()

        } else {
            statusTextField.text = ""
            statusTextField.placeholder = "You must enter text"
        }
        
        
        
        
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
}
