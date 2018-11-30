//
//  HelperService.swift
//  Tromit
//
//  Created by Stacey Smith on 11/27/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class HelperService {
    static func uploadDataToServer(data: Data, videoUrl: URL?, ratio: CGFloat, caption: String, onSuccess:  @escaping () -> Void) {
        if let videoUrl = videoUrl {
            self.uploadVideoToFirebaseStorage(videoUrl: videoUrl, onSuccess: { (videoUrl) in
                uploadImageToFirebaseStorage(data: data, onSuccess: { (thumbnailImageUrl) in
                    sendDataToDatabase(photoUrl: thumbnailImageUrl, videoUrl: videoUrl, ratio: ratio, caption: caption, onSuccess: onSuccess)
                })
            })
            //            self.senddatatodatabase
        } else {
            uploadImageToFirebaseStorage(data: data) { (photoUrl) in
                self.sendDataToDatabase(photoUrl: photoUrl, ratio: ratio, caption:caption, onSuccess: onSuccess)
            }
        }
    }
    
    static func uploadVideoToFirebaseStorage(videoUrl: URL, onSuccess: @escaping (_ videoUrl: String) -> Void) {
        
        let videoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(videoIdString)
        
        storageRef.putFile(from: videoUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { ( url, error ) in
                
                if error != nil {
                    return
                }
                
                if let videoUrl = url?.absoluteString {
                    onSuccess(videoUrl)
                }
            })
        }
    }
    
    static func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageUrl: String) -> Void) {
        
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoIdString)
        
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { ( url, error ) in
                
                if error != nil {
                    return
                }
                
                if let photoUrl = url?.absoluteString {
                    onSuccess(photoUrl)
                }
            })
        }
    }
    
    static func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil, ratio: CGFloat, caption: String, onSuccess: @escaping () -> Void) {
        
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        
        let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                let newHashTagRef = Api.HashTag.REF_HASHTAG.child(word.lowercased())
                newHashTagRef.updateChildValues([newPostId: true])
            }
            
        }
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var dict = ["uid": currentUserId, "photoUrl": photoUrl, "caption": caption, "likeCount": 0, "ratio": ratio, "timestamp": timestamp] as [String : Any]
        
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            Api.Feed.REF_FEED.child(Auth.auth().currentUser!.uid).child(newPostId!).setValue(true)
            Api.Follow.REF_FOLLOWERS.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {
                snapshot in
                let arraySnapshot = snapshot.children.allObjects as! [DataSnapshot]
                arraySnapshot.forEach({ (child) in
                    Api.Feed.REF_FEED.child(child.key).updateChildValues(["\(newPostId)": true])
                    let newNotificationId = Api.Notification.REF_NOTIFICATION.child(child.key).childByAutoId().key
                    let newNotificationReference = Api.Notification.REF_NOTIFICATION.child(child.key).child(newNotificationId!)
                    newNotificationReference.setValue(["from": Auth.auth().currentUser!.uid, "type": "feed", "objectId": newPostId!, "timestamp": timestamp])
                })
            })
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child((newPostId!))
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                }
            })
            ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
}
