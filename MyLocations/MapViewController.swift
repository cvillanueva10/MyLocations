//
//  MapViewController.swift
//  MyLocations
//
//  Created by Chris Villanueva on 7/5/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.tintColor = .blue
        view.showsUserLocation = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var locations = [Location]()
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext, queue: OperationQueue.main) { (_) in
                if self.isViewLoaded {
                    self.updateLocations()
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateLocations()
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        switch annotations.count {
        case 0:
            region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
        default:
            var topLeft = CLLocationCoordinate2DMake(-90, 180)
            var bottomRight = CLLocationCoordinate2DMake(90, -180)
            for annotation in annotations {
                topLeft.latitude = max(topLeft.latitude, annotation.coordinate.latitude)
                topLeft.longitude = min(topLeft.longitude, annotation.coordinate.longitude)
                bottomRight.latitude = min(bottomRight.latitude, annotation.coordinate.latitude)
                bottomRight.longitude = max(bottomRight.longitude, annotation.coordinate.longitude)
            }
            let center = CLLocationCoordinate2DMake(topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2, topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2)
            let extraSpace = 1.1
            let span = MKCoordinateSpanMake(abs(topLeft.latitude - bottomRight.latitude) * extraSpace, abs(topLeft.longitude - bottomRight.longitude) * extraSpace)
            region = MKCoordinateRegionMake(center, span)
        }
        
        return mapView.regionThatFits(region)
    }
    
    func updateLocations() {
        mapView.removeAnnotations(locations)
        let entity = Location.entity()
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = entity
        do {
            locations = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
        mapView.addAnnotations(locations)

    }
    
    // MAKR: - actions
    
    @objc func showLocationDetails(_ sender: UIButton) {
        let locationDetailsViewController = LocationDetailsViewController(style: .grouped)
        locationDetailsViewController.managedObjectContext = managedObjectContext
        let location = locations[sender.tag]
        locationDetailsViewController.locationToEdit = location
        navigationController?.pushViewController(locationDetailsViewController, animated: true)
    }
    
    @objc func showLocations() {
        let theRegion = region(for: locations)
        mapView.setRegion(theRegion, animated: true)
    }
    
    @objc func showUser() {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func setupUI() {
        navigationItem.title = "Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Pin"), style: .plain, target: self, action: #selector(showLocations))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "User"), style: .plain, target: self, action: #selector(showUser))
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.delegate = self
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Location else {
            return nil
        }
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView.isEnabled = true
            pinView.canShowCallout = true
            pinView.animatesDrop = false
            pinView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            pinView.tintColor = UIColor(white: 0, alpha: 0.5)
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(showLocationDetails), for: .touchUpInside)
            pinView.rightCalloutAccessoryView = rightButton
            annotationView = pinView
        }
        if let annotationView = annotationView {
            annotationView.annotation = annotation
            let button = annotationView.rightCalloutAccessoryView as! UIButton
            if let index = locations.index(of: annotation as! Location) {
                button.tag = index
            }
        }
        return annotationView
    }
}








