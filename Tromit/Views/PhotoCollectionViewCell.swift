//
//  PhotoCollectionViewCell.swift
//  Tromit
//
//  Created by Casse on 26/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    var delegate: PhotoCollectionViewCellDelegate?
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            photo.sd_setImage(with: photoUrl)
        }
        
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photoTapped))
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true
    }
    
    @objc func photoTapped() {
        if let id = post?.id {
            delegate?.goToDetailVC(postId: id)
        }
    }
}
