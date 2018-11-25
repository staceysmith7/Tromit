//
//  CameraViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/19/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class CameraViewController: UIViewController {
    
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost() {
        if selectedImage != nil {
            
            self.postButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.postButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            
            self.postButton.isEnabled = false
            self.removeButton.isEnabled = true
            self.postButton.backgroundColor = .lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectPhoto() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present (pickerController, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            let photoIdString = NSUUID().uuidString
            print(photoIdString)
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata,  error) in
                
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                storageRef.downloadURL(completion: { ( url, error ) in
                    
                    if error != nil {
                        
                        return
                    }
                    
                    if let photoUrl = url?.absoluteString {
                        self.sendDataToDatabase(photoUrl: photoUrl)
                        
                    }
                })
            })
        } else {
            
            ProgressHUD.showError("profile Image can't be Empty")
        }
    }
    
    @IBAction func removeTapped(_ sender: Any) {
        clean()
        handlePost()
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId!)
        
        guard let currentUser = Auth.auth()?.currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "caption": captionTextView.text!], withCompletionBlock: {
            (error, ref) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            ProgressHUD.showSuccess("Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        })
    }
    
    func clean() {
        
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "profileimage2")
        self.selectedImage = nil
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if  let  image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImage = image
            photo.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
