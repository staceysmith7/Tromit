//
//  HomeViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/19/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    var posts = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
    }
    
    func loadPosts() {
        Database.database().reference().child("post").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                
                let newPost = Post.transformPostPhoto(dict: dict)
                self.posts.append(newPost)
                print(self.posts)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func LogOutTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController" )
            self.present(loginVC, animated: true, completion: nil)
            
        } catch let logoutError {
            print(logoutError)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
}
