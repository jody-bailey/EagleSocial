//
//  PostSnapshot.swift
//  EagleSocial
//
//  Created by Jody Bailey on 2/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import Firebase

struct PostsSnapshot {
    
    let posts: [Post]
    
    init?(with snapshot: DataSnapshot) {
        var posts = [Post]()
        guard let snapDict = snapshot.value as? [String: [String: Any]] else { return nil }
        for snap in snapDict {
            guard let post = Post(postId: snap.key, dict: snap.value) else { continue }
            posts.append(post)
        }
        self.posts = posts
    }
}
