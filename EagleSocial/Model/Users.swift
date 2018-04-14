//
//  Users.swift
//  EagleSocial
//
//  Created by Jody Bailey on 4/9/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import Firebase

var allUsers = Users()

class Users {
    
    var people = [Person]()
    
    init() {
        self.people = []
        self.updateList()
    }
    
    public func updateList() {
        let ref = Database.database().reference()
        var people : [Person] = []
        var peopleParts = [String](repeating: "", count: 5)
        _ = ref.child("Users").observe(.value) { (snapshot) in
            guard let snapDict = snapshot.value as? [String : [String : Any]] else { return }
            self.people = [Person]()
            for snap in snapDict {
                for snip in snap.value {
                    switch(snip.key){
                    case "name":
                        peopleParts[0] = snip.value as! String
                    case "age":
                        peopleParts[1] = snip.value as! String
                    case "major":
                        peopleParts[2] = snip.value as! String
                    case "school year":
                        peopleParts[3] = snip.value as! String
                    case "email":
                        peopleParts[4] = snip.value as! String
                    default:
                        print("Error getting friend details")
                    }
                }
                people.append(Person(name: peopleParts[0], userId: snap.key, age: peopleParts[1], major: peopleParts[2], schoolYear: peopleParts[3], email: peopleParts[4]))
            }
            self.people = people
        }
    }
    
    func getUser(userId : String) -> Person {
        var user : Person?
        for person in people {
            if person.userId == userId {
                user =  person
            }
        }
        if user != nil {
            return user!
        } else
        {
            return Person()
        }
    }
    
    public func getAllUsers() -> [Person] {
        return self.people
    }
    
    func addUser(user: Person) {
        self.people.append(user)
    }
}
