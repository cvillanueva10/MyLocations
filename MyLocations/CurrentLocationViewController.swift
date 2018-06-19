
import UIKit

class CurrentLocationViewController: UIViewController {
    
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
    
    let getMyLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get My Location", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

