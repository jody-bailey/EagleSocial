//
//  MessageViewController.swift
//  EagleSocial
//
//  Created by Michael Pearson on 3/18/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var conversationTableView: UITableView!
    var keyboardHeight : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
        messageTextField.delegate = self
        
        //Register a tap gesture recognizer to detect when the conversationTableView is clicked.
        let tapGesterRecognizer = UITapGestureRecognizer(target: self, action: #selector(setter: conversationTableView))
        conversationTableView.addGestureRecognizer(tapGesterRecognizer)
        
        //Register the custom table cell MessageCell.xib
        conversationTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        
        //Add observers to see when the keyboard will show or will be dismissed.
        //Observers used to get keyboard height.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        let messageArray = ["First Message", "Second Message", "Third Message"]
        
        messageCell.messageBodyLabel.text = messageArray[indexPath.row]
        
        return messageCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backbtnPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            //TODO: get keyboard height

            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - getKayboardHeight
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        self.keyboardHeight = keyboardRectangle.height
        //print(self.keyboardHeight)
        self.heightConstraint.constant = self.keyboardHeight + CGFloat(50.0)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        self.keyboardHeight = keyboardRectangle.height
        self.heightConstraint.constant = self.keyboardHeight + CGFloat(50.0)
    }
}
