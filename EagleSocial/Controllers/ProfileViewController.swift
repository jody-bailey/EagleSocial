//
//  ProfileViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Edited and Enhanced by Lacy Simpson on 2/25/18
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var nameFromEdit :String = ""
    var ageFromEdit :String = ""
    var majorFromEdit :String = ""
    var interestFromEdit :String = ""
    var aboutFromEdit :String = ""
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userMajorLabel: UILabel!
    @IBOutlet weak var userInterestLabel: UILabel!
    @IBOutlet weak var userAboutLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // userNameLabel.text = nameFromEdit
       // userAgeLabel.text = ageFromEdit
       // userMajorLabel.text = majorFromEdit
       // userInterestLabel.text = interestFromEdit
       // userAboutLabel.text = aboutFromEdit
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        print("edit button was pressed")
        performSegue(withIdentifier: "goToEdit", sender: self)
        
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
