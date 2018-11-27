//
//  FindViewController.swift
//  Tromit
//
//  Created by Casse on 27/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class FindViewController: UIViewController {

    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        
        self.navigationItem.rightBarButtonItem = searchItem
    }
    

}
