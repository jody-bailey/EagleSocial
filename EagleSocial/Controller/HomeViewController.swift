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
        
//        likeHandle = likeRef?.child("postLikes").observe(.value, with: { (snapshot) in
//            print(snapshot)
//            print("hit the like handle")
//            guard let postsSnapshot = PostsSnapshot(with: snapshot) else { return }
//            self.posts = postsSnapshot.posts
//            self.posts.sort(by: { $0.date.compare($1.date) == .orderedDescending })
//            self.NewsFeedTable.reloadData()
//        })
        
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
            cell.profileImage.image = #imageLiteral(resourceName: "jodybobae")
            cell.profileImage.layer.cornerRadius = 32
            cell.profileImage.layer.masksToBounds = true
//            cell.statusTextField.delegate = self
            cell.statusTextField.placeholder = "Enter your status update here!"
            cell.backgroundColor = UIColor.lightGray
            
            return cell
        }
        else if indexPath.row > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! NewsFeedTableViewCell
            
            if posts[indexPath.row - 1].likes == true {
                cell.likeButton.setTitleColor(UIColorFromRGB(rgbValue: 0xFFC14C), for: .normal)
            } else {
                cell.likeButton.setTitleColor(UIColor.black, for: .normal)
            }
            
            cell.nameOfUser.text = posts[indexPath.row - 1].username
            cell.textBody.text = posts[indexPath.row - 1].message
            cell.setPost(post: [posts[indexPath.row - 1]])
            cell.profilePicture.image = #imageLiteral(resourceName: "profile_icon")
            
            cell.likeButton.tag = indexPath.row - 1
            cell.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: UIControlEvents.touchUpInside)
            cell.commentButton.addTarget(self, action: #selector(commentButtonPressed), for: UIControlEvents.touchUpInside)
            
            let userId = Auth.auth().currentUser?.uid
            
            likeRef = Database.database().reference()
            likeHandle = likeRef?.child("postLikes").child(userId!).observe(.value, with: { (snapshot) in
                guard let snapDict = snapshot.value as? [String: Int] else { return }
                for snap in snapDict {
                    if snap.key == self.posts[indexPath.row - 1].postId {
                        if snap.value == 1 {
                            self.posts[indexPath.row - 1].likes = true
                        } else {
                            self.posts[indexPath.row - 1].likes = false
                        }
                    }
                }
                
            })
            
//            commentRef = Database.database().reference()
//            commentHandle = commentRef?.child("postComments").child(posts[indexPath.row - 1].postId).observe(.value, with: { (snapshot) in
//
//                guard let snapDict = snapshot.value as? [String : [String : String]] else { return }
////                print(snapDict)
//                for (_, snap) in snapDict {
//                    for snip in snap {
//                        print(snip.value)
//
//                        let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
//
//                    }
//                }
//            })
            
            
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
        
        let userId = Auth.auth().currentUser?.uid
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.NewsFeedTable)
        let indexPath = self.NewsFeedTable.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            print("like button pressed from new function")
            if self.posts[(indexPath?.row)! - 1].likes! == true {
                self.likeRef?.child("postLikes").child(userId!).child(self.posts[(indexPath?.row)! - 1].postId).setValue(false)
                self.NewsFeedTable.reloadData()
            } else if self.posts[(indexPath?.row)! - 1].likes! == false {
                self.likeRef?.child("postLikes").child(userId!).child(self.posts[(indexPath?.row)! - 1].postId).setValue(true)
                self.NewsFeedTable.reloadData()
            }
            
            
        }
//        self.NewsFeedTable.reloadData()
    }
    
    @objc func commentButtonPressed(sender:AnyObject) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Comment", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let userId = Auth.auth().currentUser?.uid
            
            let buttonPosition = sender.convert(CGPoint.zero, to: self.NewsFeedTable)
            let indexPath = self.NewsFeedTable.indexPathForRow(at: buttonPosition)
            if indexPath != nil {
                print("comment button pressed from new function")
                
                self.commentRef?.child("postComments").child(self.posts[(indexPath?.row)! - 1].postId).childByAutoId().setValue(["user": userId!,
                                                        "comment" : textField.text!])
                
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
