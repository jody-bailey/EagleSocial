//
//  User.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/25/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation

struct User
{
    let name: String
    
    init?(username: String) {
        
        let username = username
        
        self.name = username
    }
}

//changes need to be made to the user struct to store user attributes other than user name. These other attributes are needed to share user info between view controllers. I attempted to make changes, but this caused an error with the user status table view. I reverted the changes so that the team could discuss the best approach.
