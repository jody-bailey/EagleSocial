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
    var likes = [Like]()
    let postId: String
    
    init?(postId: String, dict: [String: Any]) {
        let ref = Database.database().reference()
        self.likes = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        guard let username = dict["user"] as? String,
            let message = dict["message"] as? String,
            let dateString = dict["date"] as? String,
            let date = dateFormatter.date(from: dateString)
            else { return nil }
        
        ref.child("posts").child(postId).child("likes").observeSingleEvent(of: .value) { (snapshot) in
        
            if let likes = snapshot.children.allObjects as? [String] {
                for like in likes {
                    print("got a like")
                }
            }
        }
//        var userLikes = [Like]()
//        if dict.keys.contains("likes"){
//            let likes = dict["likes"] as? [DataSnapshot]
//            for like in likes!{
//                userLikes.append(Like(user: like))
//            }
//            self.likes = userLikes
//        } else {
//            self.likes = [Like]()
//        }
        
        
        self.postId = postId
        self.username = username
        self.message = message
        self.date = date
    }
    
}
