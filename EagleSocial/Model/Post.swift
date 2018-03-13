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
    let date: Date
    var likes: Bool?
    let postId: String
    
    init?(postId: String, dict: [String: Any]) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        guard let username = dict["user"] as? String,
            let message = dict["message"] as? String,
            let dateString = dict["date"] as? String,
            let date = dateFormatter.date(from: dateString)
            else { return nil }
        
        self.postId = postId
        self.username = username
        self.message = message
        self.date = date
//        self.likes = false
    }
    
}
