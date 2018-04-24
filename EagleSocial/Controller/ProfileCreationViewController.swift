//
//  ProfileCreationViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/25/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol DismissedView {
    func dismissed()
}

class ProfileCreationViewController: UIViewController {
    var delegate:DismissedView?
    var ref : DatabaseReference?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        let email = user?.email
        
        if let userId = user?.uid {
            let username = self.firstNameTextField.text! + " " + self.lastNameTextField.text!
            let age = "0"
            let major = "undetermined"
            let schoolYear = "undertermined"
            let aboutMe = "SMTTT"
            let changeRequest = user?.createProfileChangeRequest()
            changeRequest?.displayName = username
            
            
            changeRequest?.commitChanges { error in
                if let error = error {
                    print("Error committing change request \(error)")
                } else {
                    print("Change request successful")
                }
            }
            
            let parameters = ["name": username,
                              "email": email!,
                              "age": age,
                              "major": major,
                              "about me": aboutMe,
                              "school year": schoolYear] as [String : Any]
            
            
            ref?.child("Users/\(userId)").setValue(parameters)
        }
        
        delegate?.dismissed()
    }
    
    
    @IBAction func firstNameDone() {
    }
    
    @IBAction func lastNameDone() {
    }
    
}
