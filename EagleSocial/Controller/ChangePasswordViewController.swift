//
//  ChangePasswordViewController.swift
//  EagleSocial
//
//  Created by Jeremiah on 2/25/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cancelButton.layer.cornerRadius = 10
        self.saveButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func canelButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {

        
        
        let newPass = self.newPasswordTextField.text!
        let email = Auth.auth().currentUser?.email
        let oldPass = self.oldPasswordTextField.text!
        
        if newPass.count >= 6 {
            let credential = EmailAuthProvider.credential(withEmail: email!, password: oldPass)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
                if error == nil {
                    Auth.auth().currentUser?.updatePassword(to: newPass) { (errror) in
                        print(errror as Any)
                    }
                } else {
                    print(error as Any)
                }
            })
            
            self.dismiss(animated: true, completion: nil)
        } else {
            self.newPasswordTextField.text = ""
            self.newPasswordTextField.placeholder = "Password too short"
        }
        
    }
    
    typealias Completion = (Error?) -> Void
    
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping Completion) {
        
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
