//
//  HomeTableViewCell.swift
//  Tromit
//
//  Created by Casse on 24/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

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
        
        Api.Post.observePost(withId: post!.id!) { (post) in
            self.updateLike(post: post)
        }
        
  
        Api.Post.observeLikeCount(withPostId: post!.id!, completion: { (value) in
          self.likeCountButton.setTitle("\(value) likes", for: UIControl.State.normal)
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
        
        Api.Post.incrementLikes(postId: post!.id!, onSuccess: { (post) in
            self.updateLike(post: post)
        }) {  (errorMessage) in
            ProgressHUD.showError(errorMessage)
        
        }
        //incrementLikes(forRef: postRef)
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
