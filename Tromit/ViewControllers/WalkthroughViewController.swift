//
//  WalkthroughViewController.swift
//  Tromit
//
//  Created by Casse on 30/11/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageContent = ["Welcome, stay motivated",
                       "more motiation specifically for you",
                       "Enjoy, keep up the hard work"]
    var pageImage = ["background1", "background2", "background3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let startingVC = viewControllerAtIndex(index: 0) {
            setViewControllers([startingVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkThroughContentViewController).index
        index += 1
        return viewControllerAtIndex(index: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkThroughContentViewController).index
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    func viewControllerAtIndex(index: Int) -> WalkThroughContentViewController? {
        if index < 0 || index >= pageContent.count {
            return nil
        }
        if let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "WalkThroughContentViewController") as? WalkThroughContentViewController {
            pageContentVC.content = pageContent[index]
            pageContentVC.imageFileName = pageImage[index]
            return pageContentVC
        }
        return nil
    }
    
    func forward(index: Int) {
        if let nextVC = viewControllerAtIndex(index: index + 1) {
            setViewControllers(nextVC, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }
    }
    
}
