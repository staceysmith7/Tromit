//
//  FollowApi.swift
//  Tromit
//
//  Created by Stacey Smith on 11/27/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FollowApi {
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followAction(withUser id: String) {
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Auth.auth().currentUser!.uid).child(key).setValue(true)
                }
            }
            
        })
        
        REF_FOLLOWERS.child(id).child(Auth.auth().currentUser!.uid).setValue(true)
        REF_FOLLOWING.child(Auth.auth().currentUser!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id: String) {
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Auth.auth().currentUser!.uid).child(key).removeValue()
                }
            }
            
        })
        REF_FOLLOWERS.child(id).child(Auth.auth().currentUser!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Auth.auth().currentUser!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        REF_FOLLOWERS.child(userId).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        })
    }
    func fetchCountFollowing (userId: String,completion: @escaping (Int)-> Void) {
        REF_FOLLOWING.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    func fetchCountFollowers (userId: String,completion: @escaping (Int)-> Void) {
        REF_FOLLOWERS.child(userId).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
}
