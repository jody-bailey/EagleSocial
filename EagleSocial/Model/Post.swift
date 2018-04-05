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
    var comments : [String : Array<[String : String]>]
    
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
        var comments : [[String : String]] = []
        var postComments : [String : Array<[String : String]>] = [:]
        
        if allComments != nil {
            for comment in (allComments)! {
                let key = comment.key
//                print(comment)
                for value in comment.value {
//                    print(value)
                    comments.append([value.key : value.value])
                }
                postComments[key] = comments
            }
        }
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
        self.comments = postComments
    }
    
}
