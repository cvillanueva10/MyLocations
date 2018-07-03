//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Chris Villanueva on 6/29/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationCell: UITableViewCell {

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    let fullStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    // TODO: - fix cell configuration

    func configure(for location: Location) {
        fullStackView.addArrangedSubview(descriptionLabel)
        fullStackView.addArrangedSubview(addressLabel)
        addSubview(fullStackView)
        fullStackView.frame = frame
        let insets = UIEdgeInsetsMake(5, 5, 5, 0)
        fullStackView.frame = UIEdgeInsetsInsetRect(fullStackView.frame, insets)


        descriptionLabel.text = location.locationDescription

        if let placemark = location.placemark {
            var text = ""
            if let s = placemark.subThoroughfare {
                text += s + " "
            }
            if let s = placemark.thoroughfare {
                text += s + " "
            }
            if let s = placemark.locality {
                text += s + " "
            }
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LocationsViewController: UITableViewController {


    private let locationCellId = "locationCellId"
    var locations = [Location]()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(LocationCell.self, forCellReuseIdentifier: locationCellId)
        let fetchRequest = NSFetchRequest<Location>()
        let entity = Location.entity()
        fetchRequest.entity = entity

        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            locations = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
    }

    func configureContent(for cell: UITableViewCell, at indexPath: IndexPath) {
        let location = locations[indexPath.row]

//        cell.textLabel?.font = .preferredFont(forTextStyle: .title3)
//        cell.detailTextLabel?.font = .preferredFont(forTextStyle: .body)
//        cell.detailTextLabel?.textColor = UIColor.init(white: 0, alpha: 0.5)
//        cell.textLabel?.text = location.locationDescription
//        if let placemark = location.placemark {
//            var text = ""
//            if let s = placemark.subThoroughfare {
//                text += s + " "
//            }
//            if let s = placemark.thoroughfare {
//                text += s + " "
//            }
//            if let s = placemark.locality {
//                text += s + " "
//            }
//            cell.detailTextLabel?.text = text
//        } else {
//            cell.detailTextLabel?.text = ""
//        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellId, for: indexPath) as! LocationCell
        let location = locations[indexPath.row]
        cell.configure(for: location)
//        configureContent(for: cell, at: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
}
