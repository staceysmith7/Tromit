//
//  FilterViewController.swift
//  Tromit
//
//  Created by Casse on 29/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterPhoto: UIImageView!
    
    var selectedImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        filterPhoto.image = selectedImage
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        let ciImage = CIImage(image: selectedImage)
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if let filteredImage = filter?.value(forKey: kCIInputImageKey) as? CIImage {
            cell.filterPhoto.image = UIImage(ciImage: filteredImage)
        }
        
        return cell
    }
}
