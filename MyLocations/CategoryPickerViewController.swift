//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by Christopher Villanueva on 6/25/18.
//  Copyright © 2018 Chris Villanueva. All rights reserved.
//

import UIKit

protocol CategoryPickerViewControllerDelegate: class {
    func didSetCategoryName(with categoryName: String)
}

class CategoryPickerViewController: UITableViewController {
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Building",
        "House",
        "Ice Cream Vendor",
        "Landmark",
        "Park"
    ]
    var selectedCategoryName = ""
    var selectedIndexPath = IndexPath()
    weak var delegate: CategoryPickerViewControllerDelegate?
    private let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<categories.count {
            if categories[i] == selectedCategoryName {
                selectedIndexPath = IndexPath(row: i, section: 0)
                break
            }
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        configureTableView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        let categoryName = categories[indexPath.row]
        cell.textLabel?.text = categoryName
        if categoryName == selectedCategoryName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        cell.selectedBackgroundView = selection
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.didSetCategoryName(with: selectedCategoryName)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRow(at: indexPath) {
                newCell.accessoryType = .checkmark
            }
            if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
                oldCell.accessoryType = .none
            }
            selectedIndexPath = indexPath
            selectedCategoryName = categories[indexPath.row]
        }
    }

}
