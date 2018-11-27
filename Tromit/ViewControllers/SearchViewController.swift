//
//  SearchViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/19/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadTopPosts()
    }
    
    func loadTopPosts() {
        
    }
}
