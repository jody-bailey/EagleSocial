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
    
    init?(postId: String, dict: [String: Any]) {
        let ref = Database.database().reference()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        guard let username = dict["user"] as? String,
            let message = dict["message"] as? String,
            let dateString = dict["date"] as? String,
            let userid = dict["userId"] as? String,
            let date = dateFormatter.date(from: dateString)
            else { return nil }
        
        var allLikes : [String : Bool] = [:]
        
        let likes = dict["likes"] as? [String : Bool]
        
//        ref.child("posts").child(postId).child("likes").observeSingleEvent(of: .value) { (snapshot) in
//        print(snapshot)
//            guard let likes = snapshot.value as? [String : Bool] else { return }
//            print(likes)
//            allLikes = likes
//        }
        
        self.likes = likes ?? [:]
        self.postId = postId
        self.username = username
        self.message = message
        self.date = date
        self.userId = userid
    }
    
}
