//
//  PhotoCell.swift
//  MyLocations
//
//  Created by Christopher Villanueva on 7/5/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photo"
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let addPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    func setupLayout() {
        backgroundColor = .black
        addPhotoLabel.textColor = .white
        addPhotoLabel.highlightedTextColor = .white
        addSubview(addPhotoLabel)
        addPhotoLabel.leftAnchor.constraint(equalTo: readableContentGuide.leftAnchor).isActive = true
        addPhotoLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        addPhotoLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        addSubview(addPhotoImageView)
        addPhotoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addPhotoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addPhotoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true
        addPhotoImageView.widthAnchor.constraint(equalTo: addPhotoImageView.heightAnchor).isActive = true
        addPhotoImageView.isHidden = true
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}
