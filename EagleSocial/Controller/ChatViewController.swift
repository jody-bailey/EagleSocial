//
//  ChatViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CanRecieve {
    
    @IBOutlet weak var messageTableView: UITableView!
    
    var ref : DatabaseReference?
    var conversationRef : DatabaseReference?
    var messageRef : DatabaseReference?
    
    //Variable to hold the convestation ID of the
    //tapped row in the table.
    var tappedConversationID = ""
    
    //let conversations = ConversationList()
    var myConvos : [Conversation] = [Conversation]()
    
    
    //Constant used to set the row height for the
    //messageViewTable
    let conversationRowHeight = CGFloat(100.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set self as the delagate for the messageTableView:
        messageTableView.delegate = self
        
        //Set the DataSource of the messageTableView
        messageTableView.dataSource = self
        
        //Register a tap gesture recognizer to detect when the messageTableView is clicked.
        //let tapGesterRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        //messageTableView.addGestureRecognizer(tapGesterRecognizer)
        
        //Register the MessageListTableCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageListTableCell", bundle: nil), forCellReuseIdentifier: "MessageListCell")
        
        //Configure the messageTableView
        //See function definition for more information on what this item does.
        configureTableView()
        
        //Retrieve conversations upon loading the messageList screen.
        retrieveConversations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView DataSource Methods
    
    //Populate the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Set which custom table cell to use in the message table view.
        let conversationCell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListTableCell
        
        //let messageArray = ["First Message","Second Message","Third Message"]
        
        
        
        //Load the Last Message into the MessageBody label in the TableView MessageListTableCell
        conversationCell.messageBody.text = myConvos[indexPath.row].lastMessage
        
        //Load the SenderId into the name label in the TableView MessageListTableCell
        print("MJP1 " + myConvos[indexPath.row].getDisplayName())
        conversationCell.nameLabel.text = myConvos[indexPath.row].getDisplayName()
        
        //Load the user's profile image into the profileImageView in the TableView MessageListTableCell
        //TODO: - Modify the classes/models to pull down user's profile picture.
        conversationCell.profilePictureImageView.image = UIImage(named : "profile_icon")
        
        return conversationCell
    }
    
    //Determine which row in the table view is selected and get the conversation ID.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedConversationID = myConvos[indexPath.row].getConversationId()
        performSegue(withIdentifier: "toConversation", sender: self)
    }
    /*
     // MARK: - Navigation
     */
    
    //Determine how many rows to display.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myConvos.count
    }
    
    func retrieveConversations() {
        
        
        //Retrieve conversations as they come in.
        let conversationDB = Database.database().reference().child("Conversation").queryOrdered(byChild: "Members/" + (Auth.auth().currentUser?.uid)!).queryEqual(toValue: true)
        
        
        conversationDB.observe(.childAdded) {(snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            
            let thisConvo = Conversation(convoId: snapshot.key, mem: snapshotValue["Members"]! as! Dictionary<String, Any> , mes: snapshotValue["Messages"]! as! Dictionary<String, Any>)
            
            self.myConvos.append(thisConvo)
            
            self.configureTableView()
            
            self.messageTableView.reloadData()
            
        }//end observe child added.
        
        
    }//end retrieve conversation func
    
    //Set some display properties for the table view
    func configureTableView() {
        
        //Set the row height to be consistent for every
        //concersation in the list.
        messageTableView.rowHeight = conversationRowHeight
        
        messageTableView.separatorStyle = .singleLine
        
        
    }
    @IBAction func newConversation(_ sender: UIBarButtonItem) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConversation" {
            let messageVC = segue.destination as! MessageViewController
            messageVC.conversationID = tappedConversationID
            
            messageVC.delagate = self
        }
    }
    
    //Reset the tappedConversationID property to empty string.
    //Aides in creating a new conversation/message.
    func dataReceived(data: String) {
        tappedConversationID = data
    }
    
    
}

