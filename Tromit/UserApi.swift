//
//  UserApi.swift
//  Tromit
//
//  Created by Casse on 25/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUserByUsername(username: String, completion: @escaping (User) -> Void) {
        REF_USERS.queryOrdered(byChild: "usernameLowercase").queryEqual(toValue: username).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (User) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUsers(completion: @escaping (User) -> Void) {
        REF_USERS.observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func queryUsers(withText text: String, completion: @escaping (User) -> Void) {
        REF_USERS.queryOrdered(byChild: "usernameLowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: {
            (snapshot) in
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String: Any] {
                    let user = User.transformUser(dict: dict, key: child.key)
                    if user.id! != Auth.auth().currentUser?.uid {
                        completion(user)
                }
                }
            })
        })
    }
    //
    //    var CURRENT_USER: User? {
    //        if Auth.auth().currentUser != nil {
    //            return CURRENT_USER
    //        }
    //
    //        return nil
    //    }
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        return REF_USERS.child(currentUser.uid)
    }
}
