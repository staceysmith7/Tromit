//
//  SignUpViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/19/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.tintColor = UIColor.white
        usernameTextField.textColor = UIColor.white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.5)])
//        let bottomLayerUsername = CALayer()
//        bottomLayerUsername.frame = CGRect (x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        usernameTextField.layer.addSublayer(bottomLayerUsername)
        
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.5)])
//        let bottomLayer = CALayer()
//        bottomLayer.frame = CGRect (x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        emailTextField.layer.addSublayer(bottomLayer)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.5)])
//        let bottomLayerPassword = CALayer()
//        bottomLayerPassword.frame = CGRect (x: 0, y: 29, width: 1000, height: 0.6)
//        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
//        passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        profileImage.layer.cornerRadius = 60
        profileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        self.signUpButton.isEnabled = false
        
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField() {
        
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            self.signUpButton.setTitleColor(.blue, for: UIControl.State.normal)
            self.signUpButton.isEnabled = false
            return
        }
        
        self.signUpButton.setTitleColor(.white, for: UIControl.State.normal)
        self.signUpButton.isEnabled = true
    }
    
    @objc func handleSelectProfileImageView() {
        
        print ("Tapped")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present (pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismissOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            AuthService.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Success")
                self.performSegue(withIdentifier: "signUpToTabBarVC", sender: nil)
            }, onError: { (errorString) in
                ProgressHUD.showError(errorString!)
            })
        } else {
            
            profileImage.image = UIImage(named: "placeholderImg")
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if  let  image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

