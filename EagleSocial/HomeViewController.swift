//
//  HomeViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/24/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var NewsFeedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        
        NewsFeedTable.delegate = self
        NewsFeedTable.dataSource = self
        
        NewsFeedTable.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        configureTableView()
        
        NewsFeedTable.separatorStyle = .none
        
        NewsFeedTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! NewsFeedTableViewCell
        
        cell.nameOfUser.text = "Jody Bailey"
        cell.profilePicture.image = #imageLiteral(resourceName: "jodybobae")
        cell.profilePicture.layer.cornerRadius = 45
        cell.profilePicture.layer.masksToBounds = true
        cell.textBody.text = "This is going to be the best social media app ever created for college students!"
        
        return cell
    }
    
    func configureTableView() {
        NewsFeedTable.rowHeight = UITableViewAutomaticDimension
        NewsFeedTable.estimatedRowHeight = 240.0
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
