//
//  HomeViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    

    @IBOutlet weak var NewsFeedTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ref: DatabaseReference?
    var likeRef: DatabaseReference?
    var commentRef: DatabaseReference?
    var refHandle: DatabaseHandle?
    var likeHandle: DatabaseHandle?
    var commentHandle: DatabaseHandle?
    
    var postData = [String]()
    var posts = [Post]()
    
    var likes = [Like]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNewsFeed), name: NSNotification.Name(rawValue: "load"), object: nil)
        friendList.printList()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        NewsFeedTable.refreshControl = refreshControl
       
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        refHandle = ref?.child("posts").observe(.value, with: { (snapshot) in
            // code to handle when a new post is added
            guard let postsSnapshot = PostsSnapshot(with: snapshot) else { return }
            self.posts = postsSnapshot.posts
            self.posts.sort(by: { $0.date.compare($1.date) == .orderedDescending })
            self.NewsFeedTable.reloadData()
            
        })
        
        NewsFeedTable.delegate = self
        NewsFeedTable.dataSource = self
        
        NewsFeedTable.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        NewsFeedTable.register(UINib(nibName: "StatusUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "statusUpdateCell")
        
        NewsFeedTable.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        NewsFeedTable.addGestureRecognizer(tapGesture)
        NewsFeedTable.reloadData()
        
        configureTableView()
        
        NewsFeedTable.reloadData()
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        
        refHandle = ref?.child("posts").observe(.value, with: { (snapshot) in
            // code to handle when a new post is added
            print(snapshot)
            guard let postsSnapshot = PostsSnapshot(with: snapshot) else { return }
            self.posts = postsSnapshot.posts
            self.posts.sort(by: { $0.date.compare($1.date) == .orderedDescending })
            self.NewsFeedTable.reloadData()
            
        })
        thisUser.updateProfilePic()

        NewsFeedTable.reloadData()
        refreshControl.endRefreshing()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        let userLoginStatus = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if (userLoginStatus){
            print("user is logged in from tabbarcontroller")
        }
        else {
            print("user not logged in")
            performSegue(withIdentifier: "goToWelcomeScreen", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusUpdateCell", for: indexPath) as! StatusUpdateTableViewCell
            
            cell.shareButton.layer.cornerRadius = 10
            cell.userName.text = "Jody Bailey"
            cell.profileImage.image = thisUser.profilePic
            cell.profileImage.layer.cornerRadius = 10
            cell.profileImage.layer.masksToBounds = true
            cell.statusTextField.placeholder = "Enter your status update here!"
            cell.backgroundColor = UIColor.lightGray
            
            return cell
        }
        else if indexPath.row > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! NewsFeedTableViewCell
            
            cell.nameOfUser.text = posts[indexPath.row - 1].username
            cell.textBody.text = posts[indexPath.row - 1].message
            cell.setPost(post: [posts[indexPath.row - 1]])
            
            if (self.posts[indexPath.row - 1].userId == thisUser.userID){
                cell.profilePicture.image = thisUser.profilePic
            } else {
                cell.profilePicture.image = friendList.getFriend(userId: self.posts[indexPath.row - 1].userId).profilePic
//                cell.profilePicture.image = #imageLiteral(resourceName: "profile_icon")
            }
            cell.profilePicture.layer.cornerRadius = 10
            cell.profilePicture.layer.masksToBounds = true
            
            cell.likeButton.tag = indexPath.row - 1
            cell.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: UIControlEvents.touchUpInside)
            cell.commentButton.addTarget(self, action: #selector(commentButtonPressed), for: UIControlEvents.touchUpInside)
            cell.viewCommentsButton.addTarget(self, action: #selector(viewComments), for: UIControlEvents.touchUpInside)
            
            if self.posts[indexPath.row - 1].likes[thisUser.userID] == true {
                cell.likeButton.setTitleColor(UIColorFromRGB(rgbValue: 0xFFC14C), for: .normal)
            } else {
                cell.likeButton.setTitleColor(UIColor.black, for: .normal)
            }
            
            return cell
        }
        else {
            fatalError("Unexpected section \(indexPath.section)")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    @objc func reloadNewsFeed() {
        NewsFeedTable.reloadData()
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            
            self.view.endEditing(true);
            return false;
        }
        return true
    }
    
    func configureTableView() {
        NewsFeedTable.rowHeight = UITableViewAutomaticDimension
        NewsFeedTable.estimatedRowHeight = 240.0
    }
    
    @objc func tableViewTapped() {
        searchBar.endEditing(true)
    }
    
    @objc func likeButtonPressed(sender:AnyObject) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.NewsFeedTable)
        let indexPath = self.NewsFeedTable.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            print("like button pressed from new function")
            
            if self.posts[(indexPath?.row)! - 1].likes[thisUser.userID] == true {
                self.posts[(indexPath?.row)! - 1].likes.updateValue(false, forKey: thisUser.userID)
            } else {
                self.posts[(indexPath?.row)! - 1].likes.updateValue(true, forKey: thisUser.userID)
            }
            if !self.posts[(indexPath?.row)! - 1].likes.isEmpty {
                self.ref?.child("posts").child(self.posts[(indexPath?.row)! - 1].postId).child("likes").setValue(self.posts[(indexPath?.row)! - 1].likes)
                self.NewsFeedTable.reloadData()
            }
        }
    }
    
    @objc func commentButtonPressed(sender:AnyObject) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Comment", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let buttonPosition = sender.convert(CGPoint.zero, to: self.NewsFeedTable)
            let indexPath = self.NewsFeedTable.indexPathForRow(at: buttonPosition)
            if indexPath != nil {
                print("comment button pressed from new function")
                
                var parameters : [String : String] = [:]
                
                if (self.posts[(indexPath?.row)! - 1].userId == thisUser.userID){
//                    self.posts[(indexPath?.row)! - 1].comments["name"] = thisUser.name
//                    self.posts[(indexPath?.row)! - 1].comments["userId"] = thisUser.userID
//                    self.posts[(indexPath?.row)! - 1].comments["message"] = textField.text
                    parameters = ["name" : thisUser.name,
                                  "userId" : thisUser.userID,
                                  "message" : textField.text!]
                } else {
//                    self.posts[(indexPath?.row)! - 1].comments["name"] = friendList.getFriend(userId: self.posts[(indexPath?.row)! - 1].userId).name
//                    self.posts[(indexPath?.row)! - 1].comments["userId"] = friendList.getFriend(userId: self.posts[(indexPath?.row)! - 1].userId).userId
//                    self.posts[(indexPath?.row)! - 1].comments["message"] = textField.text
                    
                    parameters = ["name" : friendList.getFriend(userId: self.posts[(indexPath?.row)! - 1].userId).name,
                                  "userId" : friendList.getFriend(userId: self.posts[(indexPath?.row)! - 1].userId).userId,
                                  "message" : textField.text!]
                }
                
//                if !self.posts[(indexPath?.row)! - 1].comments.isEmpty {
                    self.ref?.child("posts").child(self.posts[(indexPath?.row)! - 1].postId).child("comments").childByAutoId().setValue(parameters)
                    self.NewsFeedTable.reloadData()
//                }
                
            }
            self.NewsFeedTable.reloadData()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new comment"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func viewComments(sender: AnyObject) {
        performSegue(withIdentifier: "goToComments", sender: self)
    }

}
