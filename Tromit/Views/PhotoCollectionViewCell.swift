//
//  PhotoCollectionViewCell.swift
//  Tromit
//
//  Created by Casse on 26/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
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
    }
}
