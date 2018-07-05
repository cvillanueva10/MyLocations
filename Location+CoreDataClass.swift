//
//  Location+CoreDataClass.swift
//  MyLocations
//
//  Created by Christopher Villanueva on 6/28/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    public var title: String? {
        if locationDescription?.isEmpty ?? false {
            return "(No Description)"
        } else {
            return locationDescription
        }
    }
    
    public var subtitle: String? {
        return category
    }

}
