//
//  SplitLabelView.swift
//  MyLocations
//
//  Created by Chris Villanueva on 6/19/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit

class SplitLabelView: UILabel {
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setText(left leftText: String){
        leftLabel.text = leftText
        arrangeLabels()
    }
    
    func setText(right rightText: String){
        rightLabel.text = rightText
        arrangeLabels()
    }
    
    private func arrangeLabels() {
        labelStackView.addArrangedSubview(leftLabel)
        labelStackView.addArrangedSubview(rightLabel)
        addSubview(labelStackView)
        labelStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        labelStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
