
import UIKit
import CoreLocation
import CoreData

class CurrentLocationViewController: UIViewController {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "(Message Label)"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let latitudeLabel = SplitLabelView()
    let longitudeLabel = SplitLabelView()
    
    lazy var latLongStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(latitudeLabel)
        stackView.addArrangedSubview(longitudeLabel)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "(Address goes here)"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tagButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(
            string: "Get My Location",
            attributes: [
                NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20)
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var getMyLocationButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(
            string: "Get My Location",
            attributes: [
                NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20),
                NSAttributedStringKey.foregroundColor : UIColor.white
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    var timer: Timer?
    var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyLocationButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(showTagLocation), for: .touchUpInside)
        setupUI()
        updateLabels()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    @objc func showTagLocation() {
        let locationDetailsController = LocationDetailsViewController(style: .grouped)
        locationDetailsController.placemark = placemark
        locationDetailsController.coordinate = location!.coordinate
        locationDetailsController.managedObjectContext = managedObjectContext
        navigationController?.pushViewController(locationDetailsController, animated: true)
    }

    // MARK: - UI methods

    func configureGetButton() {
        if updatingLocation {
            getMyLocationButton.setTitle("Stop", for: .normal)
        } else {
            getMyLocationButton.setTitle("Get My Location", for: .normal)
        }
    }
    
    func updateLabels() {
        if let location = location {
            let latitudeText = String(format: "%.8f", location.coordinate.latitude)
            let longitudeText = String(format: "%.8f", location.coordinate.longitude)
            latitudeLabel.setText(right: latitudeText)
            longitudeLabel.setText(right: longitudeText)
            tagButton.isHidden = false
            messageLabel.text = " "
            if let placemark = placemark {
                addressLabel.text = string(from: placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
        } else {
            latitudeLabel.setText(right: "")
            longitudeLabel.setText(right: "")
            tagButton.isHidden = true
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue{
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMessage
        }
        configureGetButton()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(messageLabel)
        latitudeLabel.setText(left: "Latitude: ")
        latitudeLabel.setText(right: "(Latitude goes here)")
        longitudeLabel.setText(left: "Longitude: ")
        longitudeLabel.setText(right: "(Longitude goes here)")
        entireStackView.addArrangedSubview(messageLabel)
        entireStackView.addArrangedSubview(latLongStackView)
        entireStackView.addArrangedSubview(addressLabel)
        entireStackView.addArrangedSubview(tagButton)
        view.addSubview(entireStackView)
        entireStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        entireStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        entireStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        view.addSubview(getMyLocationButton)
        getMyLocationButton.topAnchor.constraint(equalTo: entireStackView.bottomAnchor).isActive = true
        getMyLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35).isActive = true
        getMyLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

// MARK: - core location

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            print("didUpdateLocations \(newLocation)")
            if newLocation.timestamp.timeIntervalSinceNow < -5 {
                return
            }
            if newLocation.horizontalAccuracy < 0 {
                return
            }
            distance = CLLocationDistance(Double.greatestFiniteMagnitude)
            if let location = location {
                distance = newLocation.distance(from: location)
            }
            if location == nil ||  location!.horizontalAccuracy > newLocation.horizontalAccuracy {
                setNewLocation(with: newLocation)
                if !performingReverseGeocoding {
                    reverseGeocode(with: newLocation)
                }
            } else if distance < 1 {
                guard let timestamp = location?.timestamp else { return }
                let timeInterval = newLocation.timestamp.timeIntervalSince(timestamp)
                if timeInterval > 10 {
                    print("*** Force done!")
                    stopLocationManager()
                    updateLabels()
                }
            }
        }
    }

    func reverseGeocode(with newLocation: CLLocation) {
        print("*** Going to geocode")
        performingReverseGeocoding = true
        geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            self.lastGeocodingError = error
            if error == nil, let p = placemarks, !p.isEmpty {
                self.placemark = p.last
            } else {
                self.placemark = nil
            }
            self.performingReverseGeocoding = false
            self.updateLabels()
        }
    }

    func setNewLocation(with newLocation: CLLocation) {
        location = newLocation
        lastLocationError = nil
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
            print("*** We're done!")
            if distance > 0 {
                performingReverseGeocoding = false
            }
            stopLocationManager()
        }
        updateLabels()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
    }

    @objc func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateLabels()
    }

    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }

    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            if let timer = timer {
                timer.invalidate()
            }
        }
    }

    @objc func didTimeOut() {
        print("*** Time Out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationErrorDomain", code: 1, userInfo: nil)
            updateLabels()
        }
    }

    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

