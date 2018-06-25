//
//  Extensions.swift
//  MyLocations
//
//  Created by Christopher Villanueva on 6/24/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit
import CoreLocation

extension UIViewController {

    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        if let lotNumber = placemark.subThoroughfare {
            line1 += lotNumber + " "
        }
        if let streetName = placemark.thoroughfare {
            line1 += streetName + " "
        }
        var line2 = ""
        if let city = placemark.locality {
            line2 += city + " "
        }
        if let state = placemark.administrativeArea {
            line2 += state + " "
        }
        if let zipCode = placemark.postalCode {
            line2 += zipCode + " "
        }
        return line1 + "\n" + line2
    }
}
