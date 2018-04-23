//
//  Post.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Post {
    
    let username: String
    let message: String
    let date: Date
    var likes : [String : Bool]
    let postId: String
    let userId: String
    var comments : [Comment]
    
    init?(postId: String, dict: [String: Any]) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        guard let username = dict["user"] as? String,
            let message = dict["message"] as? String,
            let dateString = dict["date"] as? String,
            let userid = dict["userId"] as? String,
            let date = dateFormatter.date(from: dateString)
            else { return nil }
        
        let likes = dict["likes"] as? [String : Bool]
        let allComments = dict["comments"] as? [String : [String : String]]
        var commentParts : [String] = []
        var postComments = [Comment]()
        var index : Int = 0
        
        if allComments != nil {
            for comment in (allComments)! {
                for value in comment.value {
                    commentParts.append(value.value)
                }
                postComments.append(Comment(name: commentParts[0], uid: commentParts[1], message: commentParts[2], date: dateFormatter.date(from: commentParts[3])!))
                commentParts = []
                index += 1
            }
        }
        
        self.likes = likes ?? [:]
        self.postId = postId
        self.username = username
        self.message = message
        self.date = date
        self.userId = userid
        self.comments = postComments
    }
    
}
