//
//  CommentsViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 4/5/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    var keyboardHeight : CGFloat = 0.0
    
    var post : Post?
    var comments : [Comment] = []
    var ref : DatabaseReference?
    var refHandle : DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentTextField.delegate = self
        self.sendButton.layer.borderWidth = 2
        self.commentTextField.layer.cornerRadius = 10
        self.commentTextField.layer.masksToBounds = true
        
        self.sendButton.layer.cornerRadius = 10
        self.comments = (self.post?.comments)!
        
        ref = Database.database().reference()
        refHandle = ref?.child("posts").child((post?.postId)!).child("comments").observe(.value, with: { (snapshot) in
            guard let snapDict = snapshot.value as? [String : [String : Any]] else { return }
            
            self.comments = [Comment]()
            for snap in snapDict {
                var commentParts = [String]()
                
                for snip in snap.value {
                    commentParts.append(snip.value as! String)
                }
                self.comments.append(Comment(name: commentParts[0], uid: commentParts[1], message: commentParts[2]))
            }
            
            self.tableView.reloadData()
        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        
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

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.comments.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCommentCell", for: indexPath) as! CommentCell
        cell.userName.text = self.comments[indexPath.row].username
        cell.commentLabel.text = self.comments[indexPath.row].message
        if (self.comments[indexPath.row].userId == thisUser.userID){
            cell.profileImage.image = thisUser.profilePic
        } else {
            cell.profileImage.image = friendList.getFriend(userId: self.comments[indexPath.row].userId).photo
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
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        ref = Database.database().reference()
        let params = ["name" : thisUser.name,
                      "userId" : thisUser.userID,
                      "message" : self.commentTextField.text!]
        
        ref?.child("posts").child((post?.postId)!).child("comments").childByAutoId().setValue(params)
        
        self.commentTextField.text = ""
        self.commentTextField.resignFirstResponder()
    }
    
    @objc func tableViewTapped() {
        self.commentTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /***********************************************************************************************
     https://stackoverflow.com/questions/33274780/uitextfield-move-up-when-keyboard-appears-in-swift
     **********************************************************************************************/
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 208)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 208)
    }
    
    func animateViewMoving(up: Bool, moveValue : CGFloat) {
        let movementDuration : TimeInterval = 0.2
        let movement : CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
}
