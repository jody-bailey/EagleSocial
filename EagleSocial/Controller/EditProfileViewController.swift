//
//  EditProfileViewController.swift
//  EagleSocial
//
//  Created by Lacy Simpson on 2/23/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol DataSentDelegate
{
    func userEnteredData(fNameData: String, lNameData: String, ageData: String, majorData: String)
}

//credit goes to https://github.com/goktugyil/EZSwiftExtensions for the UIViewController extension to hide the keyboard when the screen is tapped
extension UIViewController {
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

class EditProfileViewController: UIViewController {

    var delegate: DataSentDelegate? = nil
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var majorText: UITextField!


    override func viewDidLoad()
    {
        super.viewDidLoad()
        firstNameText.delegate = self
        lastNameText.delegate = self
        ageText.delegate = self
        majorText.delegate = self

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneButtonPressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonPressed(_ sender: Any)
    {
        if delegate != nil
        {
            if firstNameText.text != nil && lastNameText.text != nil && ageText.text != nil && majorText.text != nil
            {
                let fNameData = firstNameText.text
                let lNameData = lastNameText.text
                let ageData = ageText.text
                let majorData = majorText.text
                delegate?.userEnteredData(fNameData: fNameData!, lNameData: lNameData!, ageData: ageData!, majorData: majorData!)

                /*let ref = Database.database().reference().child("")


                ref.updateChildValues([
                    "values": []
                    ])*/
                dismiss(animated: true, completion: nil)
            }
        }

    }


    @IBAction func editMajorDone(_ sender: UITextField) {

        majorText.resignFirstResponder()
    }


}

extension EditProfileViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
