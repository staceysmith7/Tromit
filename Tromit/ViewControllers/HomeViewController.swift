//
//  HomeViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/19/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func LogOutTapped(_ sender: Any) {
       
        do {
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
            
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController" )
        
        self.present(loginVC, animated: true, completion: nil)
        
        }
    }

