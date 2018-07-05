//
//  File.swift
//  MyLocations
//
//  Created by Chris Villanueva on 7/3/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit

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
        fullStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        fullStackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor).isActive = true
        fullStackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).isActive = true
        fullStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        if let description = location.locationDescription, description.isEmpty{
            descriptionLabel.text = "(No Description)"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        
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
