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
    
    // References and Handles for firebase
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
    
        allUsers.updateList()
        thisUser.setUserAttributes()
        
        // This allows other classes to refresh the table view when data changes.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNewsFeed), name: NSNotification.Name(rawValue: "load"), object: nil)

        // Creating the refresh control so that the user can pull down to refresh the table view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
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
        
        // Set delegate and datasource to tableView
        NewsFeedTable.delegate = self
        NewsFeedTable.dataSource = self
        
        // Registering all of the custom cells that are needed for the table view
        NewsFeedTable.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        NewsFeedTable.register(UINib(nibName: "StatusUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "statusUpdateCell")
        
        NewsFeedTable.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        // Make a tap gesture to recognize when the user touches the table view to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        NewsFeedTable.addGestureRecognizer(tapGesture)
        NewsFeedTable.reloadData()
        
        configureTableView()
        
        NewsFeedTable.reloadData()
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        
        // When the user pulls down to refresh the page then the app will
        // fetch any changes in the database
        refHandle = ref?.child("posts").observe(.value, with: { (snapshot) in
            // code to handle when a new post is added
            guard let postsSnapshot = PostsSnapshot(with: snapshot) else { return }
            self.posts = postsSnapshot.posts
            self.posts.sort(by: { $0.date.compare($1.date) == .orderedDescending })
            self.NewsFeedTable.reloadData()
            
        })
        
        thisUser.updateProfilePic()

        NewsFeedTable.reloadData()
        refreshControl.endRefreshing()
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
            
            // Setting the top cell of the table view where the user will post status updates
            cell.shareButton.layer.cornerRadius = 10
            cell.userName.text = thisUser.name
            cell.profileImage.image = thisUser.profilePic
            cell.profileImage.layer.cornerRadius = 10
            cell.profileImage.layer.masksToBounds = true
            cell.statusTextField.placeholder = "Enter your status update here!"
            cell.backgroundColor = UIColor.lightGray
            
            return cell
        }
        else if indexPath.row > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! NewsFeedTableViewCell
            
            // Setting the attributes of the cell
            cell.nameOfUser.text = posts[indexPath.row - 1].username
            cell.textBody.text = posts[indexPath.row - 1].message
            cell.setPost(post: [posts[indexPath.row - 1]])
            
            // Determining if the user that posted the current post has a profile picture,
            // if they do then display that picture and if they don't then display the default
            if (self.posts[indexPath.row - 1].userId == thisUser.userID){
                cell.profilePicture.image = thisUser.profilePic
            } else {
                cell.profilePicture.image = allUsers.getUser(userId: self.posts[indexPath.row - 1].userId).photo
            }
            
            // Styling the image of the cell
            cell.profilePicture.layer.cornerRadius = 10
            cell.profilePicture.layer.masksToBounds = true
            
            // Adding the target methods to the different buttons on the cell
            cell.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: UIControlEvents.touchUpInside)
            cell.commentButton.addTarget(self, action: #selector(commentButtonPressed), for: UIControlEvents.touchUpInside)
            cell.viewCommentsButton.addTarget(self, action: #selector(viewComments), for: UIControlEvents.touchUpInside)
            
            // Setting the text of the view comments button according to how many comments the post has
            if self.posts[indexPath.row - 1].comments.count != 1 {
                cell.viewCommentsButton.setTitle(String(self.posts[indexPath.row - 1].comments.count) + " comments", for: .normal)
            } else {
                cell.viewCommentsButton.setTitle(String(self.posts[indexPath.row - 1].comments.count) + " comment", for: .normal)
            }
            
            // Loop through the likes in the current post and count
            // the likes that have a value of true
            var likeCount : Int = 0
            for like in self.posts[indexPath.row - 1].likes {
                if like.value == true {
                    likeCount += 1
                }
            }
            
            // Setting the text of the label
            if likeCount == 1 {
                cell.likesLabel.text = String(likeCount) + " like"
            } else {
                cell.likesLabel.text = String(likeCount) + " likes"
            }
            
            // Setting the color of the likes label text based on wether the current
            // user likes that post or not
            if self.posts[indexPath.row - 1].likes[thisUser.userID] != nil {
                if self.posts[indexPath.row - 1].likes[thisUser.userID]! == true {
                    cell.likeButton.setTitleColor(UIColorFromRGB(rgbValue: 0xFFC14C), for: .normal)
                } else {
                    cell.likeButton.setTitleColor(UIColor.black, for: .normal)
                }
            }
            
            return cell
        }
        else {
            fatalError("Unexpected section \(indexPath.section)")
        }
        
    }
    
    // Function to convert an RGB color to hex
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
        NewsFeedTable.estimatedRowHeight = 500.0
    }
    
    @objc func tableViewTapped() {
        searchBar.endEditing(true)
    }
    
    // Function to update the likes for a post when the like button is pressed
    @objc func likeButtonPressed(sender:AnyObject) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.NewsFeedTable)
        let indexPath = self.NewsFeedTable.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            
            if self.posts[(indexPath?.row)! - 1].likes[thisUser.userID] == true {
                self.posts[(indexPath?.row)! - 1].likes.updateValue(false, forKey: (thisUser.userID))
            } else {
                self.posts[(indexPath?.row)! - 1].likes.updateValue(true, forKey: (thisUser.userID))
            }
            if !self.posts[(indexPath?.row)! - 1].likes.isEmpty {
                self.ref?.child("posts").child(self.posts[(indexPath?.row)! - 1].postId).child("likes").setValue(self.posts[(indexPath?.row)! - 1].likes)
                self.NewsFeedTable.reloadData()
            }
        }
    }
    
    // Function to allow the user to add a comment to the post that was selected
    // and updates the data in the database
    @objc func commentButtonPressed(sender:AnyObject) {
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add Comment", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let buttonPosition = sender.convert(CGPoint.zero, to: self.NewsFeedTable)
            let indexPath = self.NewsFeedTable.indexPathForRow(at: buttonPosition)
            if indexPath != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
                let dateString = String(describing: Date())
                
                var parameters : [String : String] = [:]
                
                parameters = ["name" : (thisUser.name),
                              "userId" : (thisUser.userID),
                              "message" : textField.text!,
                              "date" : dateString]
                
                if ((textField.text?.trimmingCharacters(in: .whitespaces)) != "") {
                    self.ref?.child("posts").child(self.posts[(indexPath?.row)! - 1].postId).child("comments").childByAutoId().setValue(parameters)
                    self.NewsFeedTable.reloadData()
                }
                
            }
            self.NewsFeedTable.reloadData()
            
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
    
    // Function to perform a segue to the CommentsViewController.swift so that the user
    // can see the comments that have been made on the post
    @objc func viewComments(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.NewsFeedTable)
        let indexPath = self.NewsFeedTable.indexPathForRow(at: buttonPosition)
        performSegue(withIdentifier: "goToComments", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.destination is CommentsViewController {
            
            let vc = segue.destination as? CommentsViewController
            if let indexPath = sender as? IndexPath {
                vc?.post = self.posts[indexPath.row - 1]
            }
        }
    }
    
    // Function that returns all of the posts
    public func getPosts() -> [Post] {
        return self.posts
    }
}
