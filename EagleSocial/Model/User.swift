//
//  User.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/25/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation

struct User {
    let name: String
    
    init?(username: String) {
        
        let username = username
        
        self.name = username
    }
}
