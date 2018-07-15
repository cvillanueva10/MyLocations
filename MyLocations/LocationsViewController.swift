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

class LocationsViewController: UITableViewController {


    private let locationCellId = "locationCellId"
    
    lazy var fetchedResultsController: NSFetchedResultsController<Location> = {
        let fetchRequest = NSFetchRequest<Location>()
        let entity = Location.entity()
        fetchRequest.entity = entity
        let sort1 = NSSortDescriptor(key: "category", ascending: true)
        let sort2 = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort1, sort2]
        fetchRequest.fetchBatchSize = 20
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: "category",
            cacheName: "Locations"
        )
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Locations"
        tableView.register(LocationCell.self, forCellReuseIdentifier: locationCellId)
        configureTableView()
        performFetch()
    }

    deinit {
        fetchedResultsController.delegate = nil
    }
    
    // MARK: - private methods
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    // MARK: - table view methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections else { return ""}
        return sectionInfo[section].name.uppercased()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let labelRect = CGRect(x: 14, y: tableView.sectionHeaderHeight - 14, width: 300, height: 14)
        let label = UILabel(frame: labelRect)
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.text = tableView.dataSource?.tableView!(tableView, titleForHeaderInSection: section)
        label.textColor = UIColor(white: 1, alpha: 0.5)
        label.backgroundColor = .clear
        let seperatorRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 0.5, width: tableView.bounds.size.width - 15, height: 0.5)
        let seperatorView = UIView(frame: seperatorRect)
        seperatorView.backgroundColor = tableView.separatorColor
        let viewRect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.sectionHeaderHeight)
        let view = UIView(frame: viewRect)
        view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        view.addSubview(label)
        view.addSubview(seperatorView)
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationDetailsViewController = LocationDetailsViewController(style: .grouped)
        locationDetailsViewController.managedObjectContext = managedObjectContext
        let location = fetchedResultsController.object(at: indexPath)
        locationDetailsViewController.locationToEdit = location
        navigationController?.pushViewController(locationDetailsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = fetchedResultsController.object(at: indexPath)
            location.removePhotoFile()
            managedObjectContext.delete(location)
            do {
                try managedObjectContext.save()
            } catch {
                fatalCoreDataError(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellId, for: indexPath) as! LocationCell
        let location = fetchedResultsController.object(at: indexPath)
        cell.configure(for: location)
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections else { return 1}
        return sectionInfo[section].numberOfObjects
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
}

extension LocationsViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      //  guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!) as? LocationCell {
                let location = controller.object(at: indexPath!) as! Location
                cell.configure(for: location)
            }
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}




