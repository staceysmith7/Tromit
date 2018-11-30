//
//  WalkThroughContentViewController.swift
//  Tromit
//
//  Created by Casse on 30/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class WalkThroughContentViewController: UIViewController {

    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    
    var index = 0
    var imageFileName = ""
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLabel.text = content
        backgroundImg.image = UIImage(named: imageFileName)
        
        pageControl.currentPage = index
        switch index {
        case 0...1:
            forwardButton.setImage(UIImage(named: "arrow"), for: UIControl.State.normal)
        case 2:
            forwardButton.setImage(UIImage(named: "doneIcon"), for: UIControl.State.normal)
        default:
            break
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        switch index {
        case 0...1:
            let pageVC = parent as! WalkthroughViewController
            pageVC.forward(index: index)
        case 2:
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "hasViewedWalkthrough")
            
            dismiss(animated: true, completion: nil)
        default:
            print("")
        }
        
    }
}
