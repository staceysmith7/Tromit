//
//  ViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/19/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect (x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayer)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect (x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        self.LoginButton.isEnabled = false
        
        handleTextField()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "loginToTabBarVC", sender: nil)
        }
    }
    
    func handleTextField() {
        
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        
        guard  let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            self.LoginButton.setTitleColor(.blue, for: UIControl.State.normal)
            self.LoginButton.isEnabled = false
            return
        }
        self.LoginButton.isEnabled = true
    }
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        AuthService.logIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "loginToTabBarVC", sender: nil)
            
        }, onError: {error in
            
            ProgressHUD.showError(error!)
        })
        
    }
}
