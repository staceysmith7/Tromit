//
//  MyPostsApi.swift
//  Tromit
//
//  Created by Casse on 26/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsApi {
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
}
