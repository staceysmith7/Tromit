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
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        fetchCurrentUser ()
    }
    
    @IBAction func changeProfileButtonTapped(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    
    func fetchCurrentUser() {
        Api.User.observeCurrentUser { (user) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            if let profileUrl = URL(string: user.profileImageUrl!){
               self.profileImageView.sd_setImage(with: profileUrl)
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let profileImg = self.profileImageView.image, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            AuthService.updateUserInfo(username: usernameTextField.text!, email: emailTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Success")
            }, onError: { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            })
            
        }
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
    }
    
}
extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if  let  image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
