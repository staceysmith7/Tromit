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
    
    func observePosts(completion: @escaping (Post) -> Void) {
        
        REF_POSTS.observe(.childAdded) { (snapshot: DataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
    func observePost(withId id: String, completion: @escaping (Post) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
}
