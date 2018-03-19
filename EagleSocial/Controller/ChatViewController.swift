//
//  ChatViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set self as the delagate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //Register the MessageListTableCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageListTableCell", bundle: nil), forCellReuseIdentifier: "MessageListCell")
        
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView DataSource Methods
    
    //Populate the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thisCell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListTableCell
        
        let messageArray = ["First Message","Second Message","Third Message"]
        
        thisCell.messageBody.text = messageArray[indexPath.row]
        thisCell.nameLabel.text = "Test Name Label"
        thisCell.profilePictureImageView.image = UIImage(named : "profile_icon")
        
        return thisCell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Determine how many rows to display.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //Set some display properties for the table view
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    @IBAction func newConversation(_ sender: UIBarButtonItem) {
    
    }
    
    
    
}
