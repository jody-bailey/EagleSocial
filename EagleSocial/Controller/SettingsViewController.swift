//
//  SettingsViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.changeNameButton.layer.cornerRadius = 15
        self.changeEmailButton.layer.cornerRadius = 15
        self.changePasswordButton.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            
        }
        catch {
            print("Error signing out!")
        }
        
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeScreen") as? HomeViewController
//        {
//            present(vc, animated: true, completion: nil)
//        }
        tabBarController?.selectedIndex = 0
    }
    @IBAction func changeNamePressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToChangeName", sender: self)
    }
    
    
    @IBAction func changeEmailPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToChangeEmail", sender: self)
        
    }
    
    @IBAction func changePasswordPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToChangePassword", sender: self)
        
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
