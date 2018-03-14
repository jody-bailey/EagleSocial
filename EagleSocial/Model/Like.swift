//
//  Like.swift
//  EagleSocial
//
//  Created by Jody Bailey on 3/13/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import FirebaseAuth

struct Like {
    
    let userId: String
    var likes: Bool?
    let postId: String
    
    init?(postId: String, dict: [String: Any]) {
        
        let user = Auth.auth().currentUser?.uid
        
        guard let username = dict[user!] as? String
            else { return nil }
        
        self.postId = postId
        self.userId = username
        self.likes = false
    }
    
}
