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

    @IBOutlet weak var emailTextField: UITextField!
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
                //self.gradientLoadingBar.hide()
                let storyboard = UIStoryboard(name: "Eagle", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "vc") as! UITabBarController
                self.present(controller, animated: true, completion: { () -> Void in
                })
                self.performSegue(withIdentifier: "goHomeFromSignUp", sender: self)
            }
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
