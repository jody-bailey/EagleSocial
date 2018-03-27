//
//  Post.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation

class Post {
    
    let username: String
    let message: String
    let date: Date
    var likes = [Like]()
    let postId: String
    
    init?(postId: String, dict: [String: Any]) {
        
        self.likes = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        guard let username = dict["user"] as? String,
            let message = dict["message"] as? String,
            let dateString = dict["date"] as? String,
            let date = dateFormatter.date(from: dateString)
            else { return nil }
        
        let likes = dict["likes"] as? [String]

        
        for like in likes! where likes != nil {
            // This is storing the user id into the array of likes
            self.likes.append(Like(user: like))
        }
        
        self.postId = postId
        self.username = username
        self.message = message
        self.date = date
    }
    
}
