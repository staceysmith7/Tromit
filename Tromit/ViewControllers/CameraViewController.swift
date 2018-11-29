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
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    var selectedImage: UIImage?
    var videoUrl: URL?
    
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
        pickerController.mediaTypes = ["public.image", "public.movie"]
        present (pickerController, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.5) {
            let ratio = profileImg.size.width / profileImg.size.height
            HelperService.uploadDataToServer(data: imageData, videoUrl: self.videoUrl, ratio: ratio, caption: captionTextView.text!, onSuccess: {
                self.clean()
                self.tabBarController?.selectedIndex = 0
                })
        } else {
            
            ProgressHUD.showError("profile Image can't be Empty")
        }
    }
    
    @IBAction func removeTapped(_ sender: Any) {
        clean()
        handlePost()
    }
    
    func clean() {
        
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "profileimage2")
        self.selectedImage = nil
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            if let thumbnailImage = self.thumbnailImageForFileUrl(videoUrl) {
                selectedImage = thumbnailImage
                photo.image = thumbnailImage
                self.videoUrl = videoUrl
            }
        }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 6, timescale: 1), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        
        return nil
    }
}
