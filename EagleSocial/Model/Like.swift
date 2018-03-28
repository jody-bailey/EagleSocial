//
//  Like.swift
//  EagleSocial
//
//  Created by Jody Bailey on 3/13/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import FirebaseAuth

class Like : Equatable {
    static func ==(lhs: Like, rhs: Like) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    
    let userId: String
    
    init(user : String) {
        
        self.userId = user
    }
    
}
