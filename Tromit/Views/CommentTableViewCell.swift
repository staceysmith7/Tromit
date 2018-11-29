//
//  CommentTableViewCell.swift
//  Tromit
//
//  Created by Casse on 25/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import KILabel

protocol CommentTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
}

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: KILabel!
    
    var delegate: CommentTableViewCellDelegate?
    var comment: Comment? {
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
        commentLabel.text = comment?.commentText
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
        commentLabel.text = ""
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabelTapped))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
    }
    
    @objc func nameLabelTapped() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
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
