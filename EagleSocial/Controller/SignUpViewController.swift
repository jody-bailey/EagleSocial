//
//  SignUpViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {
    
    var ref : DatabaseReference?
    var isDismissed: Bool = false {
        didSet {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileCreation" {
            if let modalVC1 = segue.destination as? ProfileCreationViewController {
                modalVC1.delegate = self as DismissedView
            }
        }
    }
    
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
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
            }else {
                print("Registration Successful")
                
                SVProgressHUD.dismiss()
                                
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
                
                self.performSegue(withIdentifier: "goToProfileCreation", sender: self)
             
            }
        }
        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
        
    }
}

extension SignUpViewController: DismissedView {
    func dismissed() {
        dismiss(animated: true, completion: nil)
        isDismissed = true
        self.navigationController?.popToRootViewController(animated: true)
    }
}


