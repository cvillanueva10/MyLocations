//
//  MainTabBarController.swift
//  MyLocations
//
//  Created by Chris Villanueva on 6/19/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit
import CoreData

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let currentLocationViewController = CurrentLocationViewController()
        currentLocationViewController.tabBarItem.title = "Tag"
        currentLocationViewController.managedObjectContext = managedObjectContext
        viewControllers = [currentLocationViewController]
    }

  

}
