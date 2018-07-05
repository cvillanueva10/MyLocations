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
        view.backgroundColor = .white
        let currentLocationViewController = CurrentLocationViewController()
        currentLocationViewController.tabBarItem.title = "Tag"
        let locationsViewController = LocationsViewController()
        let navLocationsViewController = UINavigationController(rootViewController: locationsViewController)
        locationsViewController.navigationItem.rightBarButtonItem = editButtonItem
        locationsViewController.tabBarItem.title = "Locations"
        let mapViewController = MapViewController()
        let navMapViewController = UINavigationController(rootViewController: mapViewController)
        navMapViewController.tabBarItem.title = "Map"
        viewControllers = [currentLocationViewController, navLocationsViewController, navMapViewController]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.isKind(of: LocationsViewController.self){
        //    navigationItem.title = "Locations"
       //     navigationItem.rightBarButtonItem = editButtonItem
        }
    }
    
    
}

