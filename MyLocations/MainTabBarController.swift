//
//  MainTabBarController.swift
//  MyLocations
//
//  Created by Chris Villanueva on 6/19/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        
        let currentLocationViewController = CurrentLocationViewController()
        currentLocationViewController.tabBarItem.title = "Tag"
        viewControllers = [currentLocationViewController]
    }

  

}
