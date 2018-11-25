//
//  PostApi.swift
//  Tromit
//
//  Created by Casse on 25/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi {
    
    var REF_POSTS = Database.database().reference().child("posts")
    
    func observePosts(completaion: @escaping () -> Void) {
        
        REF_POSTS.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completaion(newPost)
            }
        }
    }
}
