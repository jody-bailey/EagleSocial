//
//  User.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/25/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import Firebase

var thisUser = User()

class User
{
    var ref : DatabaseReference!
    var refHandle : DatabaseHandle?

    
    var userID: String
    var name: String
    var email: String
    var age: String
    var major: String
    var schoolYear: String
    var aboutMe: String
    var photo: String
    var profilePic: UIImage


    init()
    {
        self.userID = ""
        self.name = ""
        self.email = ""
        self.age = ""
        self.major = ""
        self.schoolYear = ""
        self.aboutMe = ""
        self.photo = ""
        self.profilePic = #imageLiteral(resourceName: "profile_icon")
        self.updateUser()
        self.updateProfilePic()

    }
    
    public func updateUser() {
        let userid = Auth.auth().currentUser?.uid
        self.ref = Database.database().reference()
        self.refHandle = self.ref.child("Users").child(userid!).observe(.value) { (snapshot) in
            guard let snapDict = snapshot.value as? [String : String] else { return }
            
            guard let name = snapDict["name"],
                let email = snapDict["email"],
                let age = snapDict["age"],
                let major = snapDict["major"],
                let aboutMe = snapDict["about me"],
                let schoolYear = snapDict["school year"]
                else { return }
            
            
            self.userID = userid!
            self.name = name
            self.email = email
            self.age = age
            self.major = major
            self.aboutMe = aboutMe
            self.schoolYear = schoolYear
        }
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func setName(userName: String)
    {
        self.name = userName
    }
    
    public func setProfilePic(image: UIImage) {
        self.profilePic = image
    }
    
    public func setUserAttributes()
    {
        let userid = Auth.auth().currentUser?.uid
        self.ref = Database.database().reference()
        self.refHandle = self.ref.child("Users").child(userid!).observe(.value) { (snapshot) in
            guard let snapDict = snapshot.value as? [String : String] else { return }
            
            guard let name = snapDict["name"],
                let age = snapDict["age"],
                let major = snapDict["major"],
                let aboutMe = snapDict["about me"],
                let schoolYear = snapDict["school year"]
            else { return }
            
            self.name = name
            self.age = age
            self.major = major
            self.aboutMe = aboutMe
            self.schoolYear = schoolYear
        }
        
    }
    
    public func updateUserAttributes(username: String, userAge: String, userMajor: String, userAboutMe: String, userSchoolYear: String)
    {
        name = username
        age = userAge
        major = userMajor
        aboutMe = userAboutMe
        schoolYear = userSchoolYear
    }
    
    public func updateProfilePic() {
        if Auth.auth().currentUser != nil {
        let uid : String = (Auth.auth().currentUser?.uid)!
            let storage = Storage.storage()
            let storageRef = storage.reference(withPath: "image/\(uid)/userPic.jpg")
        
        var image : UIImage?
        storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error getting image from storage, \(error)")
            } else {
                // Data for "images/island.jpg" is returned
                print("image retreived successfully")
                image = UIImage(data: data!)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            }
            if image != nil {
                self.setProfilePic(image: image!)
            }
            
            }
        }
    }    
    public func hasProfilePic() -> Bool {
        if self.profilePic != profilePic {
            return true
        } else {
            return false
        }
    }
 
}
