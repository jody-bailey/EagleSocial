//
//  MainViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true

        // Do any additional setup after loading the view.
        
        self.loginButton.layer.cornerRadius = 15
        self.signUpButton.layer.cornerRadius = 15
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("Error signing out, \(error)")
//        }
        
        if Auth.auth().currentUser != nil {
//            User.thisUser = User(username: (Auth.auth().currentUser?.displayName)!, userID: (Auth.auth().currentUser?.uid)!)
            thisUser.setUserAttributes()
            performSegue(withIdentifier: "goToNewsFeedNow", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: self)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
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
