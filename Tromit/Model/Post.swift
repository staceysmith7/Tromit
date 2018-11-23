//
//  Post.swift
//  Tromit
//
//  Created by Casse on 23/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation

class Post {
    
    var caption: String?
    var photoUrl: String?
}

extension Post {
    
    static func transformPostPhoto(dict: [String: Any]) -> Post {
        
        let post = Post()
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        
        return post
    }
    
    static func transformPostVideo() {
        
    }
}
