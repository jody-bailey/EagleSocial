//
//  Person.swift
//  EagleSocial
//
//  Created by Jody Bailey on 3/27/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Person{
    let name : String
    let age : String
    let major : String
    let schoolYear : String
    let email : String
    let userId : String
    var photo : UIImage
    var key : String?
    var aboutMe : String
    
    init(name : String, userId : String, age : String, major: String, schoolYear: String, email : String, aboutMe : String) {
        self.name = name
        self.age = age
        self.major = major
        self.schoolYear = schoolYear
        self.email = email
        self.userId = userId
        self.aboutMe = aboutMe
        self.photo = #imageLiteral(resourceName: "profile_icon")
        updateProfilePic()
    }
    
    init(name : String, userId : String, age : String, major: String, schoolYear: String, email : String) {
        self.name = name
        self.age = age
        self.major = major
        self.schoolYear = schoolYear
        self.email = email
        self.userId = userId
        self.aboutMe = "This user has not updated their about me!"
        self.photo = #imageLiteral(resourceName: "profile_icon")
        updateProfilePic()
    }
    
    init() {
        self.name = ""
        self.age = ""
        self.major = ""
        self.schoolYear = ""
        self.email = ""
        self.userId = ""
        self.aboutMe = "This user has not updated their about me!"
        self.photo = #imageLiteral(resourceName: "profile_icon")
    }
    
    public func updateProfilePic() {
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: "image/\(self.userId)/userPic.jpg")
        
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
    
    public func setProfilePic(image: UIImage) {
        self.photo = image
    }
}
