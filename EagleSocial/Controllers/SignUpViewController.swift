//
//  SignUpViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase
import GradientLoadingBar
import SVProgressHUD

class SignUpViewController: UIViewController {
    
    var ref : DatabaseReference?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let gradientLoadingBar = GradientLoadingBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.signUpButton.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func lastNameDone() {
    }
    
    @IBAction func firstNameDone() {
    }
    
    @IBAction func emailDone() {
    }
    
    @IBAction func passwordDone() {
    }
    
    @IBAction func confirmDone() {
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        //gradientLoadingBar.show()
        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
            }else {
                // success
                print("Registration Successful")
                SVProgressHUD.dismiss()
                                
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
        if let user = Auth.auth().currentUser {
            print("user's name should be set")
            let uid = user.uid
            let name = firstNameTextField.text! + " " + lastNameTextField.text!
           
            let parameters = ["name": name,
                              "userId": uid]
            ref?.child("Users").childByAutoId().setValue(parameters)
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
