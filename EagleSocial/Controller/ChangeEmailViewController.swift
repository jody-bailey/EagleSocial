//
//  ChangeEmailViewController.swift
//  EagleSocial
//
//  Created by Jeremiah on 2/25/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var oldEmailTextField: UITextField!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.saveButton.layer.cornerRadius = 10
        self.cancelButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelEmailPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let oldEmail = self.oldEmailTextField.text!
        let newEmail = self.newEmailTextField.text!
        let email = Auth.auth().currentUser?.email
        let password = self.passwordTextField.text!
        
        if oldEmail == email {
            let credential = EmailAuthProvider.credential(withEmail: email!, password: password)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
                if error == nil {
                    Auth.auth().currentUser?.updateEmail(to: newEmail) { (errror) in
                        print(errror as Any)
                    }
                    let ref = Database.database().reference()
                    ref.child("Users").child(thisUser.userID).updateChildValues(["email" : newEmail])
                } else {
                    print(error as Any)
                }
            })
            self.dismiss(animated: true, completion: nil)
        } else {
            self.oldEmailTextField.text = ""
            self.oldEmailTextField.placeholder = "Incorrect Email"
            self.newEmailTextField.text = ""
            self.passwordTextField.text = ""
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
