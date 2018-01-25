//
//  ViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
       self.loginButton.layer.cornerRadius = 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func usernameDone() {
    }
    
    @IBAction func passwordDone() {
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("\(String(describing: error))")
            }else {
                print("login successful")
                //SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goHomeFromLogin", sender: self)
            }
        }
        
        
    }
    

}

