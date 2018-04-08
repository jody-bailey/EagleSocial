//
//  User.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/25/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage



var thisUser = User()

class User
{
    var ref : DatabaseReference!
    var refHandle : DatabaseHandle?

    
    var userID: String
    var name: String
    var age: String
    var major: String
    var schoolYear: String
    var photo: String
    var profilePic: UIImage

    //let ref = Database.database().reference()
    
//    let snapshot = DataSnapshot()

    init()
    {
        self.userID = ""
        self.name = ""
        self.age = ""
        self.major = ""
        self.schoolYear = ""
        self.photo = ""
        self.profilePic = #imageLiteral(resourceName: "profile_icon")
        self.updateUser()
        self.updateProfilePic()

    }
    
    public func updateUser() {
        let userid = Auth.auth().currentUser?.uid
        self.ref = Database.database().reference()
        self.refHandle = self.ref.child("Users").child(userid!).observe(.value) { (snapshot) in
            print(snapshot)
            guard let snapDict = snapshot.value as? [String : String] else { return }
            
            guard let name = snapDict["name"],
                let age = snapDict["age"],
                let major = snapDict["major"],
                let schoolYear = snapDict["school year"]
                else { return }
            
            
            self.userID = userid!
            self.name = name
            self.age = age
            self.major = major
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
            print(snapshot)
            guard let snapDict = snapshot.value as? [String : String] else { return }
            
            guard let name = snapDict["name"],
                let age = snapDict["age"],
                let major = snapDict["major"],
                let schoolYear = snapDict["school year"]
            else { return }
            
            self.name = name
            self.age = age
            self.major = major
            self.schoolYear = schoolYear
        }
        
    }
    
    public func updateUserAttributes(username: String, userAge: String, userMajor: String, userSchoolYear: String)
    {
        name = username
        age = userAge
        major = userMajor
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
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
    
    public func hasProfilePic() -> Bool {
        if self.profilePic != profilePic {
            return true
        } else {
            return false
        }
    }
 
//    func getInstance() -> User {
//        let userId = Auth.auth().currentUser?.uid
//        self.ref = Database.database().reference()
//        var instance : User?
//
//        self.ref?.child("Users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            print(snapshot)
//            let value = snapshot.value as? NSDictionary
//            let username = value?["name"] as? String ?? ""
//            instance = User(username: username, userID: userId!)
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//
////        ref?.child("Users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
////            print(snapshot)
////            let value = snapshot.value as? NSDictionary
////            let username = value!["name"] as? String
////            instance = User(username: username!, userID: userId!)
////        })
//
//        return instance!
//    }
//
//    static let thisUser : User = {
//        let crap = User(username: "crap", userID: "crap")
//        let instance : User = crap.getInstance()
//
////        let instance = User(username: userId!)
////
//        return instance
//    }()
//
//}
}
//changes need to be made to the user struct to store user attributes other than user name. These other attributes are needed to share user info between view controllers. I attempted to make changes, but this caused an error with the user status table view. I reverted the changes so that the team could discuss the best approach.
