//
//  FeedApi.swift
//  Tromit
//
//  Created by Stacey Smith on 11/27/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    var REF_FEED  = Database.database().reference().child("feed")
    
    func observeFeed(withId id: String, completion:
        @escaping (Post) -> Void) {
        REF_FEED.child(id).observe(.childAdded, with: {
            snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
        
    }
}
