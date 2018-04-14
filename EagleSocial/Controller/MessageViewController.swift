//
//  MessageViewController.swift
//  EagleSocial
//
//  Created by Michael Pearson on 3/18/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase

protocol CanRecieve {
    func dataReceived(data: String)
}

class MessageViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CanReceiveUserData {
    
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    var selectedFriend = Person(name : "", userId : "", age: "", major: "", schoolYear: "", email: "")
    
    var delagate : CanRecieve?
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var conversationTableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var addNewUserToolBar: UIView!
    @IBOutlet var addNewUserToolBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var receipientLabel: UILabel!
    @IBOutlet var receipientLabelBackgroundView1: UIView!
    @IBOutlet var receipientLabelBackgroundView: UIView!
    @IBOutlet var addNewUserToConversationButton: UIButton!
    
    @IBOutlet var removeSelectedUserButton: UIButton!
    
    //TODO: - Relace with code to get conversationID from the Chat view controller.
    //var conversationID : String = "-L8Y8gof4Ky_3ieWi6Ek"
    var conversationID : String = ""
    
    //Used to capture the keyboard height so that the messageText field
    // Will appear above the keyboard even on different devices of differen screen
    //Sizes.
    var keyboardHeight : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the delagate of for the conversationTableView
        conversationTableView.delegate = self
        
        //Set the datasource for the conversationTableView
        conversationTableView.dataSource = self
        
        //Set the delagate for the messageTextField
        messageTextField.delegate = self
        
        //Register a tap gesture recognizer to detect when the conversationTableView is clicked.
        let tapGesterRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        conversationTableView.addGestureRecognizer(tapGesterRecognizer)
        
        //Register the custom table cell MessageCell.xib
        conversationTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        //Add observers to see when the keyboard will show or will be dismissed.
        //Observers used to get keyboard height.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Configure the conversationTableView
        //See function definition for more information on what this item does.
        configureTableView()
        
        //Hide the Add New User Tool Bar if it is an existing
        //conversation.
        updateUserInterface()
        
        if conversationID != "" {
            addNewUserToolBar.isHidden = true
            addNewUserToolBarHeightConstraint.constant = 0
        }
            //Show the Add New User Tool bar if it is a new conversation.
        else {
            addNewUserToolBar.isHidden = false
            
        }
        //Retrieve messages upon loading the message screen.
        retrieveMessage()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Populate the ConversationTableView with Data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let theirColor = UIColor(red: CGFloat(255) / 255, green: CGFloat(193) / 255, blue: CGFloat(76) / 255, alpha: 1.0)
        let myColor = UIColor.lightGray
        
        //Set which custom table cell to use in the conversation table view.
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! MessageCell
        
        //Load the Message body into the MessageBody label in the TableView Message Cell
        messageCell.messageBodyLabel.text = messageArray[indexPath.row].getMessageBody()
        
        //Load the SenderId into the name label in the TableView Message Cell
        messageCell.nameLabel.text = messageArray[indexPath.row].getSenderId()
        
        if messageArray[indexPath.row].getSenderId() == Auth.auth().currentUser?.email {
            messageCell.messageBackgroundView.backgroundColor = myColor
            messageCell.messageBodyLabel.textColor = UIColor.white
        }
        else {
            messageCell.messageBackgroundView.backgroundColor = theirColor
            //messageCell.messageBodyLabel.textColor = UIColor.white
        }
        
        //Load the user's profile image into the profilImageView in the TableView Message Cell
        //TODO: - Modify the classes/models to pull down user's profile picture.
        messageCell.profileImageView.image = UIImage(named: "profile_icon")
        
        //Post the newly created messageCell into the TableView.
        return messageCell
    }
    
    //Set how many rows to displays will display in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    @objc func tableViewTapped() {
        
        //End the editing of the messageTextField when the tableview is tapped.
        messageTextField.endEditing(true)
    }
    
    //Do something when the Send Button is Pressed
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        //Prevent blank messages from being sent.
        if messageTextField.text != "" {
            var conversationIDWasEmpty : Bool
            
            if conversationID == "" {
                conversationIDWasEmpty = true
            }
            else {conversationIDWasEmpty = false}
            
            //End editing for the messageTextField.
            messageTextField.endEditing(true)
            
            //Don't allow the user to put text in the messageTextField until
            //post of the message is finished.
            messageTextField.isEnabled = false
            
            //Don't allow the user to press the send button again until the
            //message has been sent.
            sendButton.isEnabled = false
            
            //Construct the members list for the current conversation/message.
            let members : [String : String] = [String((Auth.auth().currentUser?.uid)!) : (Auth.auth().currentUser?.displayName)!,
                                             String(selectedFriend.userId) : selectedFriend.name]
            
            //Construct the message dictionary for the current conversation/message.
            //Sender, MessageBody, Conversation
            let messageDictionary : [String : String] = ["Sender": (Auth.auth().currentUser?.email)!,
                                                         "MessageBody": messageTextField.text!,
                                                         "ConversationID" : String(conversationID)]
            
            //Build the message object to prepare sending.
            let message = Message(membersa: members, messageDictionarya: messageDictionary)
            
            //Send the message.
            self.conversationID = message.sendMessage()
            if conversationIDWasEmpty == true {
                conversationIDWasEmpty = false
                
                retrieveMessage()
            }
            //ReEnable the messageTextField so the user can compose more messages.
            self.messageTextField.isEnabled = true
            
            //ReEnable the Send Button so the user can send more messages.
            self.sendButton.isEnabled = true
            
            //Set the message text field to an empty string so that the previous message
            //does not stay in the messageTextField with the potential to be sent again.
            self.messageTextField.text = ""
            
            //retrieveMessage()
            updateUserInterface()
            
        }
    }
    func retrieveMessage()
    {
        //TODO: - Refactor this function to move firebase code to the Messages model, if possible.
        //Retrive messages as they come in.
        //Make a call to the retrieveMessages method of the
        //Message class.
        if conversationID != "" {
            
            let messageDB = Database.database().reference().child("Conversation").child(conversationID).child("Messages")
            //let messageDB = Database.database().reference().child("Conversation").child("Messages")
            //let message1 = Message()
            
            messageDB.observe(.childAdded) { (snapshot) in
                let snapshotValue = snapshot.value as! Dictionary<String,Any>
                let message1 = Message()
                
                message1.setMessageBody(messageBod: String(describing: snapshotValue["MessageBody"]!))
                message1.setSenderId(sender: String(describing: snapshotValue["Sender"]!))
                //message1.conversationID = self.conversationID
                message1.setMessageDictionary(messageDict:  ["Sender": snapshotValue["Sender"]!,
                                                             "MessageBody": snapshotValue["MessageBody"]!,
                                                             "ConversationID" : self.conversationID])
                
                //return message1
                
                //message.retrieveMessages(conversation: conversationID)
                
                self.messageArray.append(message1)
                
                self.configureTableView()
                
                self.conversationTableView.reloadData()
            }
        }
    }
    /*
     // MARK: - Navigation
     */
    @IBAction func backbtnPressed(_ sender: UIBarButtonItem) {
        
        //clear the conversation ID property.
        delagate?.dataReceived(data: "")
        
        //Dissmiss the messages screen.
        //Return to the message list.
        dismiss(animated: true, completion: nil)
        
        
        
    }
    @IBAction func addNewUserToConversation(_ sender: Any) {
        
        performSegue(withIdentifier: "selectUserToChatWith", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectUserToChatWith" {
            let selectFriendVC = segue.destination as! SelectFriendViewController
            
            selectFriendVC.delegate = self
        }
    }
    @IBAction func removeUserFromConversation(_ sender: Any) {
        receipientLabel.text = ""
        
        //TODO: - clear the userID variable too.
        updateUserInterface()
    }
    
    
    //Configure the conversationTableView properties here:
    func configureTableView() {
        //TODO: - Figureout why this line of code isn't working.
        
        //Expand the row height to fit messages of different sizes.
        conversationTableView.rowHeight = UITableViewAutomaticDimension
        
        //Default row height.
        conversationTableView.estimatedRowHeight = 120.0
        
        //Remove the seperator so there are no lines between message bubbles.
        conversationTableView.separatorStyle = .none
    }
    
    //Determine if the messageTextField has begun being edited.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.view.layoutIfNeeded()
        }
    }
    //Determine if the messageTextField has ended being edited.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50.0
            self.view.layoutIfNeeded()
        }
    }
    
    //Get Keyboard Height when keyboard shows
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        //Set the global keyboard height variable to the
        //dynamically obtained value.
        self.keyboardHeight = keyboardRectangle.height
        //print(self.keyboardHeight)    //Used for debugging
        
        //Set the heightConstraint to the keyboard hieght plus the height of the
        //Message Compose View.
        self.heightConstraint.constant = self.keyboardHeight + CGFloat(50.0)
    }
    
    //Determine when the keyboard is dismissed.
    @objc func keyboardWillHide(notification: Notification) {
        
        //Set the height constraint back to 50.
        self.heightConstraint.constant = CGFloat(50.0)
    }
    func updateUserInterface() {
        receipientLabelBackgroundView.layer.cornerRadius = 20
        if receipientLabel.text != "" {
            receipientLabelBackgroundView.backgroundColor = UIColor.white
            addNewUserToConversationButton.isHidden = true
            removeSelectedUserButton.isHidden = false
        }  else {
            receipientLabelBackgroundView.backgroundColor = UIColor(named: "Clear")
            addNewUserToConversationButton.isHidden = false
            removeSelectedUserButton.isHidden = true
        }
        
        if conversationID != "" {
            addNewUserToolBar.isHidden = true
            addNewUserToolBarHeightConstraint.constant = 0
        }
    }
    
    func userDataReceived(data: Person)
    {
        selectedFriend = data
        receipientLabel.text = selectedFriend.name
        updateUserInterface()
    }
    
}


