//
//  FriendProfileViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 4/8/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FriendProfileViewController: UITableViewController {

    var friend : Friend?
    var posts = [Post]()
    var ref : DatabaseReference?
    var refHandle : DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        tableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        ref = Database.database().reference()
        refHandle = ref?.child("posts").observe(.value, with: { (snapshot) in
            // code to handle when a new post is added
            guard let postsSnapshot = PostsSnapshot(with: snapshot) else { return }
            self.posts = postsSnapshot.posts
            self.posts.sort(by: { $0.date.compare($1.date) == .orderedDescending })
            
//            var index : Int = 0
            var done : Bool
            repeat {
                done = self.removePost(posts: self.posts)
            } while (done)
            
            self.tableView.reloadData()
            
        })
        
        
        configureTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func removePost(posts: [Post]) -> Bool {
        for (i, post) in posts.enumerated() {
            if post.userId != self.friend?.userId {
                self.posts.remove(at: i)
                return true
            }
        }
        return false
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.posts.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileHeaderCell
            cell.profilePic.image = friend!.profilePic
            cell.nameLabel.text = friend!.name
            cell.ageLabel.text = "Age: " + friend!.age
            cell.majorLabel.text = "Major: " + friend!.major
            cell.gradYearLabel.text = "Grad year: " + friend!.schoolYear
            cell.aboutMeLabel.text = "This is going to be the users bio."
            
            return cell
        } else if indexPath.section >= 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! NewsFeedTableViewCell
            cell.nameOfUser.text = posts[indexPath.section - 1].username
            cell.textBody.text = posts[indexPath.section - 1].message
            cell.setPost(post: [posts[indexPath.section - 1]])
            
            if (self.posts[indexPath.section - 1].userId == thisUser.userID){
                cell.profilePicture.image = thisUser.profilePic
            } else {
                cell.profilePicture.image = friendList.getFriend(userId: self.posts[indexPath.section - 1].userId).profilePic
            }
            cell.profilePicture.layer.cornerRadius = 10
            cell.profilePicture.layer.masksToBounds = true
            
            cell.likeButton.tag = indexPath.section - 1
            cell.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: UIControlEvents.touchUpInside)
            cell.commentButton.addTarget(self, action: #selector(commentButtonPressed), for: UIControlEvents.touchUpInside)
            cell.viewCommentsButton.addTarget(self, action: #selector(viewComments), for: UIControlEvents.touchUpInside)
            
            var likeCount : Int = 0
            for like in self.posts[indexPath.section - 1].likes {
                if like.value == true {
                    likeCount += 1
                }
            }
            
            if likeCount == 1 {
                cell.likesLabel.text = String(likeCount) + " like"
            } else {
                cell.likesLabel.text = String(likeCount) + " likes"
            }
            
            if self.posts[indexPath.section - 1].likes[thisUser.userID] != nil {
                if self.posts[indexPath.section - 1].likes[thisUser.userID]! == true {
                    cell.likeButton.setTitleColor(UIColorFromRGB(rgbValue: 0xFFC14C), for: .normal)
                } else {
                    cell.likeButton.setTitleColor(UIColor.black, for: .normal)
                }
            }
            
            return cell
        }  else {
            fatalError("Unexpected section \(indexPath.section)")
        }

    }
    
    @objc func likeButtonPressed(sender:AnyObject) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            
            if self.posts[(indexPath?.section)! - 1].likes[thisUser.userID] == true {
                self.posts[(indexPath?.section)! - 1].likes.updateValue(false, forKey: (thisUser.userID))
            } else {
                self.posts[(indexPath?.section)! - 1].likes.updateValue(true, forKey: (thisUser.userID))
            }
            if !self.posts[(indexPath?.section)! - 1].likes.isEmpty {
                self.ref?.child("posts").child(self.posts[(indexPath?.section)! - 1].postId).child("likes").setValue(self.posts[(indexPath?.section)! - 1].likes)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func commentButtonPressed(sender:AnyObject) {
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add Comment", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
            if indexPath != nil {
                
                var parameters : [String : String] = [:]
                
                parameters = ["name" : (thisUser.name),
                              "userId" : (thisUser.userID),
                              "message" : textField.text!]
                
                if ((textField.text?.trimmingCharacters(in: .whitespaces)) != "") {
                    self.ref?.child("posts").child(self.posts[(indexPath?.section)! - 1].postId).child("comments").childByAutoId().setValue(parameters)
                    self.tableView.reloadData()
                }
                
            }
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new comment"
            textField.keyboardType = .default
            textField.autocapitalizationType = .sentences
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func viewComments(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        performSegue(withIdentifier: "goToCommentsFromFriend", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.destination is CommentsViewController {
            
            let vc = segue.destination as? CommentsViewController
            if let indexPath = sender as? IndexPath {
                vc?.post = self.posts[indexPath.section - 1]
            }
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
