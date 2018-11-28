//
//  SearchViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/19/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadTopPosts()
    }
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadTopPosts()
    }
      
    func loadTopPosts() {
        ProgressHUD.show("Loading...", interaction: false)
        self.posts.removeAll()
        self.collectionView.reloadData()
        Api.Post.observeTopPosts { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DiscoverDetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender as! String
            detailVC.postId = postId
        }
    }
}

extension DiscoverViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
}

extension DiscoverViewController: UICollectionViewDelegate {
    
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

extension DiscoverViewController: PhotoCollectionViewCellDelegate {
    
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "DiscoverDetailSegue", sender: postId)
    }
}
