//
//  ProfileViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Edited and Enhanced by Lacy Simpson on 2/25/18
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, DataSentDelegate
{
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var schoolYearLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func userEnteredData(fNameData: String, lNameData: String, ageData: String, majorData: String)
    {
        firstNameLabel.text = fNameData
        lastNameLabel.text = lNameData
        ageLabel.text = ageData
        majorLabel.text = majorData
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit"
        {
            let editProfileViewController: EditProfileViewController = segue.destination as! EditProfileViewController
            editProfileViewController.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editButtonPressed(_ sender: Any)
    {
        performSegue(withIdentifier: "goToEdit", sender: self)
    }

}
