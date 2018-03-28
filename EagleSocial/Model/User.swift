//
//  User.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/25/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase


let thisUser = User(username: (Auth.auth().currentUser?.displayName!)!, userID: (Auth.auth().currentUser?.uid)!)

class User
{
    let userID: String
    let name: String
    let age: String
    let major: String
    let schoolYear: String
    let photo: String


    init(username: String, userID: String)
{
    self.userID = userID
    self.name = username
    self.age = ""
    self.major = ""
    self.schoolYear = ""
    self.photo = ""
}

/*init(username: String, userAge: String, userMajor: String, userSchoolYear: String, userPhoto: String)
{
    
    let username = username
    let userAge = userAge
    let userMajor = userMajor
    let userSchoolYear = userSchoolYear
    let userPhoto = userPhoto
    
    let name: String
    let uid: String
    
    init(username: String, uid: String) {
        
        let username = username
        
        self.name = username
        self.uid = uid
    }*/
    
    public func getName() -> String {
        return self.name
    }
    
    static let thisUser : User = {
        let userId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("Users").child(userId!)
        var instance : User?
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String ?? ""
            instance = User(username: username, userID: userId!)
        })


//        let instance = User(username: userId!)
//
        return instance!
    }()
}

//changes need to be made to the user struct to store user attributes other than user name. These other attributes are needed to share user info between view controllers. I attempted to make changes, but this caused an error with the user status table view. I reverted the changes so that the team could discuss the best approach.
