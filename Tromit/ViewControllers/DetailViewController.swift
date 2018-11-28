//
//  DetailViewController.swift
//  Tromit
//
//  Created by Casse on 28/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var postId = ""
    var post = Post()
    var user = User()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
    }
    
    func loadPost() {
        Api.Post.observePost(withId: postId) { (post) in
            guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.user = user
            completed()
        })
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! HomeTableViewCell
        cell.post = post
        cell.user = user
//        cell.delegate = self
        
        return cell
    }
}

//extension DetailViewController: De
