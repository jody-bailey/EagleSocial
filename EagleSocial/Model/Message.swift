//
//  Message.swift
//  EagleSocial
//
//  Created by Michael Pearson on 3/18/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import Firebase

class Message {
    
    private var senderId : String
    private var messageBody : String
    private var conversationID : String
    private var messageDictionary : Dictionary<String, Any>
    private var members : Dictionary<String,Bool>
    
    init() {
        senderId = ""
        messageBody = ""
        conversationID = ""
        
        messageDictionary = ["Sender" : "a", "MessageBody" : "b", "ConversationID": "c"]
        members = ["abc": true, "123": true]
    }
    init(membersa: Dictionary<String, Bool>, messageDictionarya: Dictionary<String, Any>)
    {
        senderId = String(describing: messageDictionarya["Sender"]!)
        messageBody = String(describing: messageDictionarya["MessageBody"]!)
        conversationID = String(describing: messageDictionarya["ConversationID"]!)
        
        messageDictionary = messageDictionarya
        members = membersa
    }
    
    //MARK: - Send Messages
    func sendMessage() -> String
    {
        let conversationDB = Database.database().reference().child("Conversation")
        //let messagesDB = conversationDB.child("Messages")
        //conversationID = String(describing: messageDictionary["ConversationID"])
        //conversationID = conversationIDb
        
        //If this is a new conversation
        if conversationID == "Optional(\"\")" || conversationID == "" {
            conversationID = conversationDB.childByAutoId().key
            messageDictionary["ConversationID"] = conversationID
            let convo = Conversation(convoId: conversationID, mem: members, mes: messageDictionary)
            convo.postNewConversation()
            
            /*conversationDB.child(conversationID).updateChildValues(["Members" : members]) {
             (error, reference) in
             
             
             if error != nil {
             print(error!)
             
             } else {
             
             
             conversationDB.child(self.conversationID).child("Messages").childByAutoId().updateChildValues(self.messageDictionary)
             
             print (self.conversationID + " Message saved successfully!!")
             }
             }
             conversationDB.child(conversationID + "/LastMessage").setValue(messageDictionary["MessageBody"])
             {
             (error, reference) in
             
             if error != nil {
             print(error!)
             
             } else {
             
             print ("Message saved successfully!!")
             }
             }*/
        }
            //If this is an existing conversation
        else  {
            conversationDB.child(conversationID).child("Messages").childByAutoId().updateChildValues(messageDictionary) {
                (error, reference) in
                
                if error != nil {
                    print(error!)
                    
                } else {
                    
                    print ("Message saved successfully!!")
                }
            }
            conversationDB.child(conversationID + "/LastMessage").setValue(messageDictionary["MessageBody"])
            {
                (error, reference) in
                
                if error != nil {
                    print(error!)
                    
                } else {
                    
                    print ("Message saved successfully!!")
                }
            }
        }
        return conversationID
    }
    
    //MARK: - Receive Messages
    //TODO: - Refactor to use the class to retrieve messages from the database.
    
    /* func retrieveMessages(conversation: String) -> Message {
     
     //let conversationDB = Database.database().reference().child("Conversation")
     
     //Members/CurrentUserID
     //.queryOrdered(byChild: "Members/" + (Auth.auth().currentUser?.uid)!)
     //.queryEqual(toValue: true)
     let messageDB = Database.database().reference().child("Conversation").child(conversation).child("Messages")
     let message1 = Message()
     
     messageDB.observe(.childAdded) { (snapshot) in
     let snapshotValue = snapshot.value as! Dictionary<String,Any>
     
     
     message1.setMessageBody(messageBod: String(describing: snapshotValue["MessageBody"]!))
     message1.setSenderId(sender: String(describing: snapshotValue["Sender"]!))
     message1.conversationID = conversation
     message1.setMessageDictionary(messageDict:  ["Sender": snapshotValue["Sender"]!,
     "MessageBody": snapshotValue["MessageBody"]!,
     "ConversationID" : conversation])
     }
     return message1
     }*/
    
    //MARK: - Getters
    func getSenderId() -> String {
        return senderId
    }
    func getMessageBody() -> String {
        return messageBody
    }
    func getConversationID() -> String {
        return conversationID
    }
    func getMessageDictionary() -> Dictionary <String, Any> {
        return messageDictionary
    }
    func getMembers() -> Dictionary <String, Bool> {
        return members
    }
    
    //MARK: - Setters
    func setSenderId(sender: String) {
        senderId = sender
    }
    func setMessageBody(messageBod: String) {
        messageBody = messageBod
    }
    func setMessageDictionary(messageDict: Dictionary<String, Any>) {
        messageDictionary = messageDict
    }
}

