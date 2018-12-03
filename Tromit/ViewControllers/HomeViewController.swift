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
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        //UITabBar.appearance().shadowImage = nil

        
        tableView.estimatedRowHeight = 465
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 468
        tableView.dataSource = self
        loadPosts()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //navigationController?.setToolbarHidden(true, animated: false)
//        let screenSize: CGRect = UIScreen.main.bounds
//        let screenWidth = screenSize.width
////        let nav = self.navigationController?.navigationBar
////        let imageView = UIImageView(frame: CGRect(x:0,y:0,width: screenWidth, height:40))
////        imageView.contentMode = .scaleAspectFit
////
////        let image = UIImage(named: "bg4")
////        imageView.image = image
////
////        navigationItem.titleView = imageView
//        let imageView = UIImageView(frame: CGRect(x:0,y:0,width: screenWidth, height:40))
//        let image = UIImage(named: "bg4")
//       imageView.contentMode = .scaleAspectFill
//    navigationController?.navigationBar.setBackgroundImage(image, for: .default)
//
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        navigationController?.setToolbarHidden(false, animated: true)
//
//    }
//
    func loadPosts() {
        
        Api.Feed.observeFeed(withId: Auth.auth().currentUser!.uid) {
            (post) in
            guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.posts.insert(post, at: 0)
                
                //self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            })
        }
        
        Api.Feed.observeFeedRemoved(withID: Auth.auth().currentUser!.uid) { (post) in
            self.posts = self.posts.filter { $0.id != post.id }
            self.users = self.users.filter { $0.id != post.uid }
            self.tableView.reloadData()
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users.insert(user, at: 0)
            completed()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        if segue.identifier == "HomeToProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
        }
        
        if segue.identifier == "HomeHashTagSegue" {
            let hashTagVC = segue.destination as! HashTagViewController
            let tag = sender as! String
            hashTagVC.tag = tag
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
        cell.delegate = self
        
        return cell
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "CommentSegue", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "HomeToProfileSegue", sender: userId)
    }
    
    func goToHashTag(tag: String) {
        performSegue(withIdentifier: "HomeHashTagSegue", sender: tag)
    }
}
