//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Christopher Villanueva on 6/22/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

class LocationDetailsViewController: UITableViewController {

    var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    var categoryLabelText: String = "No Category"
    var latitudeText: String?
    var longitudeText: String?
    var dateText: String?

    let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photo"
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let addressDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "77 Beale St San Francisco CA"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let descriptionViewCell = UITableViewCell()
    let addPhotoViewCell = UITableViewCell()
    let addressViewCell = UITableViewCell()
    var coordinate = CLLocationCoordinate2DMake(0, 0)
    var placemark: CLPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        descriptionTextView.text = ""
        latitudeText = String(format: "%.8f", coordinate.latitude)
        longitudeText = String(format: "%.8f", coordinate.longitude)
        if let placemark = placemark {
            addressDetailLabel.text = string(from: placemark)
        } else {
            addressDetailLabel.text = "No Address Found"
        }
        dateText = format(date: Date())
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }

    private func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath != nil && indexPath!.row == 0 && indexPath!.row == 0 {
            return
        }
        descriptionTextView.resignFirstResponder()
    }

    @objc func handleDone() {
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        hudView.text = "Tagged"
        let delayInSeconds = 0.6
        afterDelay(delayInSeconds) {
            hudView.hide()
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }

    func setupUI() {
        navigationItem.title = "Tag Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
        descriptionViewCell.addSubview(descriptionTextView)
        descriptionTextView.leftAnchor.constraint(equalTo: descriptionViewCell.readableContentGuide.leftAnchor).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: descriptionViewCell.readableContentGuide.rightAnchor).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionViewCell.topAnchor, constant: 10).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: descriptionViewCell.bottomAnchor, constant: -10).isActive = true
        addPhotoViewCell.addSubview(addPhotoLabel)
        addPhotoLabel.leftAnchor.constraint(equalTo: addPhotoViewCell.readableContentGuide.leftAnchor).isActive = true
        addPhotoLabel.widthAnchor.constraint(equalTo: addPhotoViewCell.widthAnchor, multiplier: 0.75).isActive = true
        addPhotoLabel.heightAnchor.constraint(equalTo: addPhotoViewCell.heightAnchor).isActive = true
        addressViewCell.addSubview(addressLabel)
        addressLabel.leftAnchor.constraint(equalTo: addressViewCell.readableContentGuide.leftAnchor).isActive = true
        addressLabel.widthAnchor.constraint(equalTo: addressViewCell.widthAnchor, multiplier: 0.5).isActive = true
        addressLabel.heightAnchor.constraint(equalTo: addressViewCell.heightAnchor).isActive = true
        addressViewCell.addSubview(addressDetailLabel)
        addressDetailLabel.rightAnchor.constraint(equalTo: addressViewCell.readableContentGuide.rightAnchor).isActive = true
        addressDetailLabel.widthAnchor.constraint(equalTo: addressViewCell.widthAnchor, multiplier: 0.5).isActive = true
        addressDetailLabel.heightAnchor.constraint(equalTo: addressViewCell.heightAnchor).isActive = true
    }

    // MARK: - table view delegates

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Description"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 4
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 88
        } else if indexPath.section == 2 && indexPath.row == 2{
            addressDetailLabel.frame.size = CGSize(width: view.bounds.size.width, height: 10000)
            addressDetailLabel.sizeToFit()
            addressDetailLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 16
            return addressDetailLabel.frame.size.height + 20
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let categoryPickerViewController = CategoryPickerViewController()
            categoryPickerViewController.selectedCategoryName = categoryLabelText
            categoryPickerViewController.delegate = self
            navigationController?.pushViewController(categoryPickerViewController, animated: true)
        } 
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .value1, reuseIdentifier: "CellID")
        cell.detailTextLabel?.textColor = .black
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell = descriptionViewCell
                cell.selectionStyle = .none
            } else if indexPath.row == 1{
                cell.textLabel?.text = "Category"
                cell.detailTextLabel?.text = categoryLabelText
                cell.accessoryType = .disclosureIndicator
            }
        case 1:
            cell = addPhotoViewCell
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text = "Latitude"
                cell.detailTextLabel?.text = latitudeText
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Longitude"
                cell.detailTextLabel?.text = longitudeText
            } else if indexPath.row == 2 {
                cell = addressViewCell
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "Date"
                cell.detailTextLabel?.text = dateText
            }
        default:
            break
        }
        return cell
    }
}

extension LocationDetailsViewController: CategoryPickerViewControllerDelegate {
    func didSetCategoryName(with categoryName: String) {
        categoryLabelText = categoryName
        tableView.reloadData()
    }
    
}




