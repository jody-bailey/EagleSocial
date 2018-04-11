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

//method is loaded after the VC has loaded its view hierarchy into memory
class EditProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return schoolYears[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schoolYears.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.schoolYearPicked = schoolYears[row]
    }
    

    // variables for the text boxes and the cancel button of the EditProfileViewController Class
    let schoolYears = ["Freshman", "Sophomore", "Junior", "Senior", "Senior+", "Graduate"]
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var majorText: UITextField!
    @IBOutlet weak var schoolYearPickerView: UIPickerView!
    var schoolYearPicked: String = ""
    var fullNameArray = thisUser.name.components(separatedBy: " ")
    // variable is still needed for the picker for the schoolYear

    override func viewDidLoad()
    {
        super.viewDidLoad()
        thisUser.updateProfilePic()
        self.hideKeyboardWhenTappedAround()
        thisUser.updateUser()
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
            if firstNameText.text != nil && lastNameText.text != nil && ageText.text != nil && majorText.text != nil
            {
                var fNameData = firstNameText.text
                var lNameData = lastNameText.text
                var ageData = ageText.text
                var majorData = majorText.text
                var schoolYearData = schoolYearPicked
             
                if firstNameText.text == ""{
                    fNameData = fullNameArray[0]
                }
                if lastNameText.text == ""{
                    lNameData = fullNameArray[1]
                }
                if ageText.text == ""{
                    ageData = thisUser.age
                }
                if majorText.text == ""{
                    majorData = thisUser.major
                }
                if schoolYearData == ""{
                    schoolYearData = thisUser.schoolYear
                }
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                let fullName = fNameData! + " " + lNameData!
                ref.child("Users").child(thisUser.userID).updateChildValues(["name": fullName,
                                                                             "age": ageData!,
                                                                             "major": majorData!,
                                                                             "school year": schoolYearData])
                thisUser.updateUserAttributes(username: fullName, userAge: ageData!, userMajor: majorData!, userSchoolYear: schoolYearData)
                
                let user = Auth.auth().currentUser
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.displayName = fullName
                changeRequest?.commitChanges { error in
                    if let error = error {
                        print("Error committing change request \(error)")
                    } else {
                        print("Change request successful")
                    }
                }
                
                dismiss(animated: true, completion: nil)
            }
        }


}

