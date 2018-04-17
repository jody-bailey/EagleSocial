//
//  ProfileViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Edited and Enhanced by Lacy Simpson on 2/25/18
//  Copyright © 2018 Jody Bailey. All rights reserved.
//
// ProfileViewController displays the users first and last name as well as a profile photo, age, major,
// school year, and the users status updates. The ProfileViewController also allows the user
// to select an edit profile button and an upload photo button. 
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var postCount: Int = 0
        for post in posts{
            if post.userId == thisUser.userID
            {
                userPosts.append(post)
                postCount += 1
            }
        }
        return postCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeCell", for: indexPath) as! AboutMeCell
                cell.setAboutMe()
                return cell
            }
            if indexPath.row > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! NewsFeedTableViewCell
                for post in posts{
                    if post.userId == thisUser.userID
                    {
                        userPosts.append(post)
                    }
                }
                cell.nameOfUser.text = userPosts[indexPath.row - 1].username
                cell.textBody.text = userPosts[indexPath.row - 1].message
                cell.setPost(post: [userPosts[indexPath.row - 1]])
                
              //  if (self.userPosts[indexPath.row - 1].userId == thisUser.userID){
                    cell.profilePicture.image = thisUser.profilePic
                //}
                cell.profilePicture.layer.cornerRadius = 10
                cell.profilePicture.layer.masksToBounds = true
                
                cell.likeButton.tag = indexPath.row
                cell.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: UIControlEvents.touchUpInside)
                cell.commentButton.addTarget(self, action: #selector(commentButtonPressed), for: UIControlEvents.touchUpInside)
                cell.viewCommentsButton.addTarget(self, action: #selector(viewComments), for: UIControlEvents.touchUpInside)
                
                var likeCount : Int = 0
                for like in self.userPosts[indexPath.row - 1].likes {
                    if like.value == true {
                        likeCount += 1
                    }
                }
                
                if likeCount == 1 {
                    cell.likesLabel.text = String(likeCount) + " like"
                } else {
                    cell.likesLabel.text = String(likeCount) + " likes"
                }
                
                if self.userPosts[indexPath.row - 1].likes[thisUser.userID] != nil {
                    if self.userPosts[indexPath.row - 1].likes[thisUser.userID]! == true {
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
    
    //variables for the profile VC which contains labels to display the users attributes
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var schoolYearLabel: UILabel!
    @IBOutlet weak var userStatusTableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var ref: DatabaseReference?
    var likeRef: DatabaseReference?
    var commentRef: DatabaseReference?
    var refHandle: DatabaseHandle?
    var likeHandle: DatabaseHandle?
    var commentHandle: DatabaseHandle?
    
    var postData = [String]()
    var posts = [Post]()
    var userPosts = [Post]()
    
    var likes = [Like]()
   
    //method is loaded after the VC has loaded its view hierarchy into memory
    override func viewDidLoad()
    {
        super.viewDidLoad()
        allUsers.updateList()
        if Auth.auth().currentUser != nil {
        thisUser.setUserAttributes()
        userNameLabel.text = thisUser.name
        ageLabel.text = thisUser.age
        majorLabel.text = thisUser.major
        schoolYearLabel.text = thisUser.schoolYear
        self.getUserProfilePic()
        }
            
            NotificationCenter.default.addObserver(self, selector: #selector(reloadNewsFeed), name: NSNotification.Name(rawValue: "load"), object: nil)
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        userStatusTableView.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        refHandle = ref?.child("posts").observe(.value, with: { (snapshot) in
            // code to handle when a new post is added
            guard let postsSnapshot = PostsSnapshot(with: snapshot) else { return }
            self.posts = postsSnapshot.posts
            
            self.posts.sort(by: { $0.date.compare($1.date) == .orderedDescending })
            self.userStatusTableView.reloadData()
            })

            userStatusTableView.delegate = self
            userStatusTableView.dataSource = self
            
            userStatusTableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
            
            userStatusTableView.register(UINib(nibName: "AboutMeCell", bundle: nil), forCellReuseIdentifier: "AboutMeCell")
            
            userStatusTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
            
            
            configureTableView()
            
            userStatusTableView.reloadData()
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            thisUser.setUserAttributes()
            thisUser.updateProfilePic()
            userNameLabel.text = thisUser.name
            ageLabel.text = thisUser.age
            majorLabel.text = thisUser.major
            schoolYearLabel.text = thisUser.schoolYear
        }
    }
    //method uses action sheets to choose an image for the picture box on the profile VC
    @IBAction func chooseImage(_ sender: Any)
    {
        //an action sheet is raised when the user selects the choose image button with the
        //following title and message
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        let imagePickerControler = UIImagePickerController()
        imagePickerControler.delegate = self
        imagePickerControler.allowsEditing = true

        
        //User has the choice of selecting the camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerControler.sourceType = .camera
            self.present(imagePickerControler, animated: true, completion: nil)
            
        }))
        //user has the choice of selecting the photo library
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerControler.sourceType = .photoLibrary
            self.present(imagePickerControler, animated: true, completion: nil)
        }))
        
        //if the user selects the cancel button the action sheet is dismissed
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func getUserProfilePic(){
        if Auth.auth().currentUser != nil {
            let uid : String = (Auth.auth().currentUser?.uid)!
            let storage = Storage.storage()
            let storageRef = storage.reference(withPath: "image/\(uid)/userPic.jpg")
            
            var image : UIImage?
            storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error getting image from storage, \(error)")
                } else {
                    // Data for "images/island.jpg" is returned
                    print("image retreived successfully")
                    image = UIImage(data: data!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
                if image != nil {
                    self.imageView.image = thisUser.profilePic
                }
            }
            
        }

    }
    
    //method uses the users selected image as their profile photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            self.imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
        saveUserProfilePicToFireBase()
            
        }
    
    //user can cancel their selection to dismiss the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // some code for this function is derived from https://github.com/maranathApp/WhatsApp-Clone/blob/master/WhatsAppClone/AuthenticationService.swift 
    func saveUserProfilePicToFireBase()
    {
        var data = Data()
        data = UIImagePNGRepresentation(self.imageView.image!)!
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imagePath = "image/\(thisUser.userID)/userPic.jpg"
        let imageRef = storageRef.child(imagePath)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data, metadata: metadata)
        
        thisUser.updateProfilePic()
    }

    //method prepares the segue to go to the edit profile view controller when the edit button is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit"
        {
            let editProfileViewController: EditProfileViewController = segue.destination as! EditProfileViewController
        }
    }
    
    //method to deallocate memory when the available amount of memory is low
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //perform the segue that takes the user to the edit profile view controller
    @IBAction func editButtonPressed(_ sender: Any)
    {
        performSegue(withIdentifier: "goToEdit", sender: self)
    }
    
    @objc func reloadNewsFeed() {
        userStatusTableView.reloadData()
    }
    @objc func doSomething(refreshControl: UIRefreshControl) {
        
        refHandle = ref?.child("posts").observe(.value, with: { (snapshot) in
            // code to handle when a new post is added
            guard let postsSnapshot = PostsSnapshot(with: snapshot) else { return }
            self.posts = postsSnapshot.posts
            self.posts.sort(by: { $0.date.compare($1.date) == .orderedDescending })
            self.userStatusTableView.reloadData()
            
        })

        thisUser.updateProfilePic()
        
        userStatusTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func configureTableView() {
        userStatusTableView.rowHeight = UITableViewAutomaticDimension
        userStatusTableView.estimatedRowHeight = 500.0
    }

    @objc func likeButtonPressed(sender:AnyObject) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.userStatusTableView)
        let indexPath = self.userStatusTableView.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            
            if self.posts[(indexPath?.row)!].likes[thisUser.userID] == true {
                self.posts[(indexPath?.row)!].likes.updateValue(false, forKey: (thisUser.userID))
            } else {
                self.posts[(indexPath?.row)!].likes.updateValue(true, forKey: (thisUser.userID))
            }
            if !self.posts[(indexPath?.row)!].likes.isEmpty {
                self.ref?.child("posts").child(self.posts[(indexPath?.row)!].postId).child("likes").setValue(self.posts[(indexPath?.row)!].likes)
                self.userStatusTableView.reloadData()
            }
        }
    }
    
    @objc func commentButtonPressed(sender:AnyObject) {
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add Comment", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let buttonPosition = sender.convert(CGPoint.zero, to: self.userStatusTableView)
            let indexPath = self.userStatusTableView.indexPathForRow(at: buttonPosition)
            if indexPath != nil {
                
                var parameters : [String : String] = [:]
                
                //                if (self.posts[(indexPath?.row)! - 1].userId == thisUser.userID){
                parameters = ["name" : (thisUser.name),
                              "userId" : (thisUser.userID),
                              "message" : textField.text!]
                //                } else {
                //
                //                    parameters = ["name" : friendList.getFriend(userId: self.posts[(indexPath?.row)! - 1].userId).name,
                //                                  "userId" : friendList.getFriend(userId: self.posts[(indexPath?.row)! - 1].userId).userId,
                //                                  "message" : textField.text!]
                //                }
                
                if ((textField.text?.trimmingCharacters(in: .whitespaces)) != "") {
                    self.ref?.child("posts").child(self.posts[(indexPath?.row)!].postId).child("comments").childByAutoId().setValue(parameters)
                    self.userStatusTableView.reloadData()
                }
                
            }
            self.userStatusTableView.reloadData()
            
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
        let buttonPosition = sender.convert(CGPoint.zero, to: self.userStatusTableView)
        let indexPath = self.userStatusTableView.indexPathForRow(at: buttonPosition)
        performSegue(withIdentifier: "goToComments", sender: indexPath)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

