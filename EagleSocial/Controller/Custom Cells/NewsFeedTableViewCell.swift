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

protocol commentProtocol {
    func showAlert()
}

class NewsFeedTableViewCell: UITableViewCell {
    
    var delegate: commentProtocol?

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameOfUser: UILabel!
    @IBOutlet weak var textBody: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var viewCommentsButton: UIButton!
    
    var ref: DatabaseReference!
    var liked: Bool = false
    var post = [Post]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textBody.sizeToFit()
        // Initialization code
        ref = Database.database().reference()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
    }
    
    //MARK: - Comment Button Pressed
    @IBAction func commentButtonPressed(_ sender: UIButton) {
    }
    func setPost(post: [Post]) {
        self.post = post
    }
    
    func getLiked() -> Bool {
        return liked
    }
    
}
