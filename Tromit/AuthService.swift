//
//  AuthService.swift
//  Tromit
//
//  Created by Stacey Smith on 11/21/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation
import FirebaseAuth

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
    


static func  signUp (email: String,  password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
        
        if error != nil{
            onError(error!.localizedDescription)
            return
        }
        onSuccess()
        
    })
    
}

}
