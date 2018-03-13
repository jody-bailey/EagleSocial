//
//  NewsFeedTableViewCell.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameOfUser: UILabel!
    @IBOutlet weak var textBody: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var ref: DatabaseReference!
    var liked: Bool = false
    var post = [Post]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ref = Database.database().reference()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
        print("like button pressed")
        if (liked) {
            liked = false
            post[0].likes = false
        }else {
            liked = true
            post[0].likes = true
        }
        
        print(post[0])
        let userId = Auth.auth().currentUser?.uid
        let postId = post[0].postId
        self.ref.child("postLikes").child(userId!).child(postId).setValue(true)
        
        
    }
    
    func setPost(post: [Post]) {
        self.post = post
    }
    
    func getLiked() -> Bool {
        return liked
    }
    
    
}
