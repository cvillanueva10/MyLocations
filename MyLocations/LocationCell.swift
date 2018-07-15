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
        label.textColor = .white
        label.highlightedTextColor = .white
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 1, alpha: 0.4)
        label.highlightedTextColor = UIColor(white: 1, alpha: 0.5)
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.contentMode = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        selectedBackgroundView = selection
        thumbnailImageView.layer.cornerRadius = 26
        thumbnailImageView.clipsToBounds = true
        separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
    }
    
    // TODO: - fix cell configuration


    
    func configure(for location: Location) {
        backgroundColor = .black
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(addressLabel)
        let thumbnailWidth: CGFloat = frame.height - 10
        let thumbnailHeight: CGFloat = frame.height - 10
        thumbnailImageView.widthAnchor.constraint(equalToConstant: thumbnailWidth).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: thumbnailHeight).isActive = true
        horizontalStackView.addArrangedSubview(thumbnailImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        addSubview(horizontalStackView)
        horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        if location.hasPhoto, let image = location.photoImage {
            thumbnailImageView.image = image.resized(withBounds: CGSize(width: thumbnailWidth, height: thumbnailHeight))
        } else {
            thumbnailImageView.image = #imageLiteral(resourceName: "No Photo")
        }

        if let description = location.locationDescription, description.isEmpty{
            descriptionLabel.text = "(No Description)"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        
        if let placemark = location.placemark {
            var text = ""
            text.add(text: placemark.subThoroughfare)
            text.add(text: placemark.thoroughfare, separatedBy: " ")
            text.add(text: placemark.locality, separatedBy: " ")
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
