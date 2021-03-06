//
//  FilterViewController.swift
//  Tromit
//
//  Created by Casse on 29/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import CoreImage


protocol  FilterViewControllerDelegate {
    func updatePhoto(image: UIImage)
    
}

class FilterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterPhoto: UIImageView!
    var delegate: FilterViewControllerDelegate?
    var selectedImage: UIImage!
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    
    
    var context = CIContext(options: nil)
    
    
    var imageOrientation: UIImage.Orientation!
    
    
//    var fixedImage = UIImage? = scaleAndRotateImage(imageView.image)
//    if let anImage = fixedImage?.cgImage{
//        img = CIImage(cgImage: anImage)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        filterPhoto.image = selectedImage

    }
   
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.delegate?.updatePhoto(image: self.filterPhoto.image!)
    }
    
//    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
//        let scale = newWidth / image.size.width
//        let newHeight = image.size.height * scale
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
//        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//    }
    
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CIFilterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        
//        let newImage = (image: selectedImage)
        let ciImage = CIImage(image: selectedImage)
        let filter = CIFilter(name: CIFilterNames[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filteredImage =  filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredImage, from: filteredImage.extent)
            cell.filterPhoto.image = UIImage(cgImage: result!)
        
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ciImage = CIImage(image: selectedImage)
        let filter = CIFilter(name: CIFilterNames[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredImage, from: filteredImage.extent)
            self.filterPhoto.image = UIImage(cgImage: result!)
            
        }
    }
}

//extension UIImage {
//    func fixedOrientation() -> UIImage? {
//        guard imageOrientation != UIImage.Orientation.up else {
//            //This is default orientation, don't need to do anything
//            return self.copy() as? UIImage
//        }
//        guard let cgImage = self.cgImage else {
//            //CGImage is not available
//            return nil
//        }
//
//        return UIImage(cgImage: cgImage)
//    }
//}

//let newImage = UIGraphicsGetImageFromCurrentImageContext()!
//UIGraphicsEndImageContext()

//cell.filterPhoto.image = UIImage(cgImage: result!)
