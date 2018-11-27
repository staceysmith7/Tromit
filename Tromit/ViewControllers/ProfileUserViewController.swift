//
//  ProfileUserViewController.swift
//  Tromit
//
//  Created by Casse on 27/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import Firebase

class ProfileUserViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User!
    var posts: [Post] = []
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchMyPosts()
        
    }
    
    func fetchUser() {
        Api.User.observeUser(withId: userId) { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
            
        }
    }
    
    func fetchMyPosts() {
        Api.MyPosts.REF_MYPOSTS.child(userId).observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        })
    }
}

extension ProfileUserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
        }
        return headerViewCell
    }
}

extension ProfileUserViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeFirItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
        
        
    }
}
