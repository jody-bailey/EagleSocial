//
//  ProfileViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Edited and Enhanced by Lacy Simpson on 2/25/18
//  Copyright © 2018 Jody Bailey. All rights reserved.
//
// ProfileViewController displays the users first and last name as well as a profile photo, age, major,
// school year, and the users status updates. The ProfileViewController also allows the user
// to select an edit profile button and an upload photo button. 
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class ProfileViewController: UIViewController, DataSentDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate /*, UITableViewDelegate, UITableViewDataSource*/
{
    //variables for the profile VC which contains labels to display the users attributes
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var schoolYearLabel: UILabel!
    @IBOutlet weak var userStatusTableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    //method is loaded after the VC has loaded its view hierarchy into memory
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //code to load the userstatus table view up which pulls the users previous "status's or post
        //from the database
       /* userStatusTableView.delegate = self
        userStatusTableView.dataSource = self*/
    }
    
    //method uses action sheets to choose an image for the picture box on the profile VC
    @IBAction func chooseImage(_ sender: Any)
    {
        //an action sheet is raised when the user selects the choose image button with the
        //following title and message
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        let imagePickerControler = UIImagePickerController()
        imagePickerControler.delegate = self
        imagePickerControler.allowsEditing = true

        
        //User has the choice of selecting the camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerControler.sourceType = .camera
            self.present(imagePickerControler, animated: true, completion: nil)
            
        }))
        //user has the choice of selecting the photo library
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerControler.sourceType = .photoLibrary
            self.present(imagePickerControler, animated: true, completion: nil)
        }))
        
        //if the user selects the cancel button the action sheet is dismissed
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    //method uses the users selected image as their profile photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            self.imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
        saveUserProfilePicToFireBase()
            
        }
    
    //user can cancel their selection to dismiss the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
   /* func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }*/
    
    //method updates the labels on the profile page with values that were edited on the edit profile
    //view controller 
    func userEnteredData(fNameData: String, lNameData: String, ageData: String, majorData: String)
    {
        firstNameLabel.text = fNameData
        lastNameLabel.text = lNameData
        ageLabel.text = ageData
        majorLabel.text = majorData
    }
    
    
    // some code for this function is derived from https://github.com/maranathApp/WhatsApp-Clone/blob/master/WhatsAppClone/AuthenticationService.swift 
    func saveUserProfilePicToFireBase()
    {
        var data = Data()
        data = UIImagePNGRepresentation(self.imageView.image!)!
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imagePath = "image/\(thisUser.userID)/userPic.jpg"
        let imageRef = storageRef.child(imagePath)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data, metadata: metadata)
        
        thisUser.updateProfilePic()
    }

    //method prepares the segue to go to the edit profile view controller when the edit button is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit"
        {
            let editProfileViewController: EditProfileViewController = segue.destination as! EditProfileViewController
            editProfileViewController.delegate = self
        }
    }
    
    //method to deallocate memory when the available amount of memory is low
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //perform the segue that takes the user to the edit profile view controller
    @IBAction func editButtonPressed(_ sender: Any)
    {
        performSegue(withIdentifier: "goToEdit", sender: self)
    }

}
