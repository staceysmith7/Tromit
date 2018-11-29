//
//  SettingViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/29/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        fetchCurrentUser ()
    }
    func fetchCurrentUser() {
        Api.User.observeCurrentUser { (user) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            if let profileUrl = URL(string: user.profileImageUrl!){
               self.profileImage.sd_setImage(with: profileUrl)
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
    }
    
}
