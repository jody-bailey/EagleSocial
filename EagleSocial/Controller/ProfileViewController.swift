//
//  ProfileViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Edited and Enhanced by Lacy Simpson on 2/25/18
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController
{
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var schoolYearLabel: UILabel!
    
    var firstNamePassedOver : String?
    var lastNamePassedOver : String?
    var agePassedOver : String?
    var majorPassedOver : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        firstNameLabel.text = firstNamePassedOver
        lastNameLabel.text  = lastNamePassedOver
        ageLabel.text  = agePassedOver
        majorLabel.text  = majorPassedOver
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
    
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
     
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
