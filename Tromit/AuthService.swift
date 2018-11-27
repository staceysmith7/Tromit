//
//  AuthService.swift
//  Tromit
//
//  Created by Stacey Smith on 11/21/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthService {
    
    static func logIn (email: String,  password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            
            onSuccess()
        })
        
    }
    
    static func  signUp(username: String, email: String,  password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { ( user, error ) in
            
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            let userId = user?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profileImage").child(userId!)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata,  error) in
                
                if error != nil {
                    return
                }
                
                storageRef.downloadURL(completion: { ( url, error ) in
                    
                    if error != nil {
                        return
                    }
                    
                    if let profileImageUrl = url?.absoluteString {
                        
                        let values = ["username": username, "usernameLowercase": username.lowercased(), "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: userId!, values: values, onSuccess: onSuccess)
                    }
                })
            })
        })
    }
    
    static func registerUserIntoDatabaseWithUID(uid: String, values: [String: String], onSuccess: @escaping () -> Void) {
        
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values)
        onSuccess()
    }
    static func logout(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
    do {
    try Auth.auth().signOut()
    onSuccess()
    
    } catch let logoutError {
onError(logoutError.localizedDescription)
    }
    }
    
}
