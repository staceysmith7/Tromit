//
//  HomeTableViewCell.swift
//  Tromit
//
//  Created by Casse on 24/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC: HomeViewController?
    var postRef: DatabaseReference!
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView() {
        
        captionLabel.text = post!.caption
        
        if let photoUrlString = post!.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        Api.Post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value, with: {
            snapshot in
            if let value = snapshot.value as? Int {
                self.likeCountButton.setTitle("\(value) likes", for: UIControl.State.normal)
            }
        })
        
        Api.Post.REF_POSTS.child(post!.id!).observe(.childChanged, with: {
            snapshot in
            if let value = snapshot.value as? Int {
                self.likeCountButton.setTitle("\(value) likes", for: UIControl.State.normal)
            }
        })
    }
    
    func updateLike(post: Post) {
        
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            likeCountButton.setTitle("\(count) likes", for: UIControl.State.normal)
        } else {
            likeCountButton.setTitle("be the first to", for: UIControl.State.normal)
        }
    }
    
    func setupUserInfo() {
        
        nameLabel.text = user?.username
        
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = ""
        captionLabel.text = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageViewTapped))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageViewTapped))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
        
    }
    
    @objc func likeImageViewTapped() {
        postRef = Api.Post.REF_POSTS.child(post!.id!)
        incrementLikes(forRef: postRef)
    }
    
    func incrementLikes(forRef ref: DatabaseReference) {
        
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
         }
    }
    
    @objc func commentImageViewTapped() {
        
        if let id = post?.id {
            homeVC?.performSegue(withIdentifier: "commentSegue", sender: id)
        }
    }
    
    override func prepareForReuse() {
        super.awakeFromNib()
        
        profileImageView.image = UIImage(named: "placeholderImg")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
