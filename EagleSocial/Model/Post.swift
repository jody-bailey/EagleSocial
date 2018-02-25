//
//  Post.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation

struct Post {
    
    let username: String
    let message: String
    
    init?(postId: String, dict: [String: Any]) {
        guard let username = dict["user"] as? String,
            let message = dict["message"] as? String
            else { return nil }
        
        self.username = username
        self.message = message
    }
    
}
