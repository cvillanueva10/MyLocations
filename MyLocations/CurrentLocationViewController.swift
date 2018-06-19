
import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "(Message Label)"
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
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tag Button", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var getMyLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get My Location", for: .normal)
        button.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateLabels()
    }
    
    // MARK: - core location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
             print("didUpdateLocations \(newLocation)")
            location = newLocation
            updateLabels()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - UI methods
    
    func updateLabels() {
        if let location = location {
            let latitudeText = String(format: "%.8f", location.coordinate.latitude)
            let longitudeText = String(format: "%.8f", location.coordinate.longitude)
            latitudeLabel.setText(right: latitudeText)
            longitudeLabel.setText(right: longitudeText)
            tagButton.isHidden = false
            messageLabel.text = " "
        } else {
            latitudeLabel.setText(right: "")
            longitudeLabel.setText(right: "")
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
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
        entireStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        entireStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        
        view.addSubview(getMyLocationButton)
        getMyLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35).isActive = true
        getMyLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

