//
//  Post_CommentApi.swift
//  Tromit
//
//  Created by Casse on 25/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation

import FirebaseDatabase

class Post_CommentApi {
    
    var REF_POSTS_COMMENTS = Database.database().reference().child("post-comment")
}
