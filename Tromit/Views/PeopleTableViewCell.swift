//
//  PeopleTableViewCell.swift
//  Tromit
//
//  Created by Stacey Smith on 11/27/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import FirebaseAuth

class PeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        if user!.isFollowing! == true {
            configureUnfollowButton()
        } else {
            confiureFollowButton ()
        }
        
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
//        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControl.Event.touchUpInside)
    }
    
    func confiureFollowButton () {
        self.followButton.setTitle("Follow", for: UIControl.State.normal)
    }
    
    func configureUnfollowButton() {
        self.followButton.setTitle("Following", for: UIControl.State.normal)
    }
    
    @objc func followAction () {
        
        Api.Follow.followAction(withUser: user!.id!)
    }
    
    @objc func unFollowAction () {
        
        Api.Follow.unFollowAction(withUser: user!.id!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
