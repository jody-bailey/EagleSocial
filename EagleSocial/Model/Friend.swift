//
//  Friend.swift
//  EagleSocial
//
//  Created by Jody Bailey on 3/27/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation

class Friend {
    
    // Variables to store the friends name and email
    let name : String
    let email : String
    
    // Initialize the friend with name and email
    init(name : String, email : String) {
        let name : String = name
        let email : String = email
        
        self.name = name
        self.email = email
    }
}
