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
import SDWebImage

class HomeViewController: UIViewController {
    
    var posts = [Post]()
    var users = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        tableView.estimatedRowHeight = 521
        tableView.rowHeight = 521
        tableView.dataSource = self
        loadPosts()
    }
    
    func loadPosts() {
        
        Api.Feed.observeFeed(withId: Auth.auth().currentUser!.uid) {
            (post) in
            guard let postId = post.uid else {
                            return
                        }
                        self.fetchUser(uid: postId, completed: {
                            self.posts.append(post)
                            //self.activityIndicatorView.stopAnimating()
                            self.tableView.reloadData()
                        })
                    }
        
        Api.Feed.observeFeedRemoved(withID: Auth.auth().currentUser!.uid) { (key) in
            
            for (index, post ) in self.posts.enumerated() {
                if post.id == key {
                    self.posts.remove(at: index)
                }
            }
            self.tableView.reloadData()
            
        }
        
        
//        activityIndicatorView.startAnimating()
//        Api.Post.observePosts() { (post) in
//            guard let postId = post.uid else {
//                return
//            }
//            self.fetchUser(uid: postId, completed: {
//                self.posts.append(post)
//                self.activityIndicatorView.stopAnimating()
//                self.tableView.reloadData()
//            })
//        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
    }
    
    @IBAction func LogOutTapped(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController" )
            self.present(loginVC, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.homeVC = self
        
        return cell
    }
}
