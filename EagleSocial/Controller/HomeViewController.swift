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
    var refHandle: DatabaseHandle?
    
    var postData = [String]()
    
    var posts = [Post]()
    
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
            print(snapshot)
            guard let postsSnapshot = PostsSnapshot(with: snapshot) else { return }
            self.posts = postsSnapshot.posts
            self.posts.sort(by: { $0.date.compare($1.date) == .orderedDescending })
            self.NewsFeedTable.reloadData()
            
        })
        
        NewsFeedTable.delegate = self
        NewsFeedTable.dataSource = self
        
        NewsFeedTable.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        NewsFeedTable.register(UINib(nibName: "StatusUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: "statusUpdateCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        NewsFeedTable.addGestureRecognizer(tapGesture)
        
        configureTableView()
        
        //NewsFeedTable.separatorStyle = .none
        
        NewsFeedTable.reloadData()
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        print("Hello World!")
        
        refHandle = ref?.child("posts").observe(.value, with: { (snapshot) in
            // code to handle when a new post is added
            print(snapshot)
            guard let postsSnapshot = PostsSnapshot(with: snapshot) else { return }
            self.posts = postsSnapshot.posts
            self.posts.sort(by: { $0.date.compare($1.date) == .orderedDescending })
            self.NewsFeedTable.reloadData()
            
        })
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
            cell.nameOfUser.text = posts[indexPath.row - 1].username
            cell.textBody.text = posts[indexPath.row - 1].message
            
            
            return cell
        }
        else {
            fatalError("Unexpected section \(indexPath.section)")
        }
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
