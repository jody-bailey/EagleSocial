//
//  ViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

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
        
        performSegue(withIdentifier: "goHomeFromLogin", sender: self)
    }
    

}

