//
//  Extensions.swift
//  MyLocations
//
//  Created by Christopher Villanueva on 6/24/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit
import CoreLocation

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

let CoreDataSaveFailedNotification = Notification.Name("CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}

extension UIImage {
    func resized(withBounds bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / size.width
        let verticalRatio = bounds.height / size.height
        let ratio = min(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

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

extension UIViewController {

    func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
    }


}
