//
//  EditProfileViewController.swift
//  EagleSocial
//
//  Created by Lacy Simpson on 2/23/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//
//  EditProfileViewController gives the user an interface with text boxes that allows the user
//  to change their attributes. The EditProfileViewController will store the users edited information
//  in the Firebase database. Once the user either hits the cancel button or the save button the user
//  will be redirected to the ProfileViewController.
//

import UIKit
import Firebase
import FirebaseDatabase

//protocol is used to call the usersEnteredData method to delegate the users entered information into
//the ProfileViewController
protocol DataSentDelegate
{
    func userEnteredData(fNameData: String, lNameData: String, ageData: String, majorData: String)
}



//method is loaded after the VC has loaded its view hierarchy into memory
class EditProfileViewController: UIViewController {

    // variables for the text boxes and the cancel button of the EditProfileViewController Class
    var delegate: DataSentDelegate? = nil
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var majorText: UITextField!
    // variable is still needed for the picker for the schoolYear

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneButtonPressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }

    // When the user presses the save button the delegate checks to make sure the user entered
    // values in the text boxes. If the user did enter data then the data is passed via the
    // delegate to the ProfileViewController to update the text labels 
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        if delegate != nil
        {
            if firstNameText.text != nil && lastNameText.text != nil && ageText.text != nil && majorText.text != nil
            {
                let fNameData = firstNameText.text
                let lNameData = lastNameText.text
                let fullName = fNameData! + " " + lNameData!
                let ageData = ageText.text
                let majorData = majorText.text
                delegate?.userEnteredData(fNameData: fNameData!, lNameData: lNameData!, ageData: ageData!, majorData: majorData!)
                
                
                var ref: DatabaseReference!
                
                ref = Database.database().reference()
                
                ref.child("Users").child(thisUser.userID).updateChildValues(["name": fullName,
                                                                             "age": ageData!,
                                                                             "major": majorData!])
                dismiss(animated: true, completion: nil)
            }
        }

    }


}

