//
//  CommentsViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 4/5/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController {

    var post : Post?
    var comments : [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(post!)
        self.comments = (self.post?.comments)!
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "customCommentCell")
        
        configureTableView()
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCommentCell", for: indexPath) as! CommentCell
        cell.userName.text = self.comments[indexPath.row].username
        cell.commentLabel.text = self.comments[indexPath.row].message
        if (self.comments[indexPath.row].userId == thisUser.userID){
            cell.profileImage.image = thisUser.profilePic
        } else {
            cell.profileImage.image = friendList.getFriend(userId: self.comments[indexPath.row].userId).profilePic
            //                cell.profilePicture.image = #imageLiteral(resourceName: "profile_icon")
        }
        // Configure the cell...
        cell.profileImage.layer.cornerRadius = 10
        cell.profileImage.layer.masksToBounds = true

        return cell
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240.0
    }
    
}
