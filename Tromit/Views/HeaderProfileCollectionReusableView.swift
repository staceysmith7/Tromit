//
//  HeaderProfileCollectionReusableView.swift
//  Tromit
//
//  Created by Casse on 26/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCounterLabel: UILabel!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        Api.User.observeCurrentUser { (user) in
            self.nameLabel.text = user.username
            if let photoUrlString = user.profileImageUrl {
                let photoUrl = URL(string: photoUrlString)
                self.profileImage.sd_setImage(with: photoUrl)
                
            }
        }
    }
}
