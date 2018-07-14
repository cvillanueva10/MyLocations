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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setupViewControllers() {
        view.backgroundColor = .white
        let currentLocationViewController = CurrentLocationViewController()
        let navCurrentLocationViewController = UINavigationController(rootViewController: currentLocationViewController)
        currentLocationViewController.navigationController?.isNavigationBarHidden = true
        navCurrentLocationViewController.tabBarItem.title = "Tag"
        navCurrentLocationViewController.tabBarItem.image = #imageLiteral(resourceName: "Tag")
        let locationsViewController = LocationsViewController()
        let navLocationsViewController = UINavigationController(rootViewController: locationsViewController)
        locationsViewController.navigationItem.rightBarButtonItem = editButtonItem
        navLocationsViewController.tabBarItem.title = "Locations"
        navLocationsViewController.tabBarItem.image = #imageLiteral(resourceName: "Locations")
        let mapViewController = MapViewController()
        let navMapViewController = UINavigationController(rootViewController: mapViewController)
        navMapViewController.tabBarItem.title = "Map"
        navMapViewController.tabBarItem.image = #imageLiteral(resourceName: "Map")
        viewControllers = [navCurrentLocationViewController, navLocationsViewController, navMapViewController]
    }
}

