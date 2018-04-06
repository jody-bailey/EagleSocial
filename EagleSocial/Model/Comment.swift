//
//  Comment.swift
//  EagleSocial
//
//  Created by Jody Bailey on 4/5/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation

class Comment {
    let username : String
    let userId : String
    let message : String
    
    init(name : String, uid : String, message : String) {
        self.username = name
        self.userId = uid
        self.message = message
    }
}
