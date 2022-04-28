//
//  MapViewController.swift
//  RideSharer
//
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let locationManager = CLLocationManager()
    let regionRadius: Double = 2000.0
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            showLocationServicesDisabledAlert()
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerMapOnUserLocation()
        case .denied:
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.showLocationNeededAlert()
            }
        case.notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
            centerMapOnUserLocation()
        case .restricted:
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.showLocationNeededAlert()
            }
        case .authorizedAlways:
            mapView.showsUserLocation = true
            centerMapOnUserLocation()
        @unknown default:
            fatalError()
        }
    }
    
    private func centerMapOnUserLocation() {
        
        guard let userCoordinate = locationManager.location?.coordinate else {
            return
        }
        let coordinateRegion = MKCoordinateRegion(center: userCoordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - Delegates for MapView
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        centerMapOnUserLocation()
    }
}

// MARK: - Configure Alerts
extension MapViewController {
    
    private func showLocationNeededAlert() {
        
        let title = NSLocalizedString("Location Needed", comment: "Title for user location needed alert")
        let message = NSLocalizedString("Your location services are not enabled for this app. Please go to your settings to allow this app to use your location.", comment: "Message for user location needed alert")
        let locationNeededAlert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let actionTitle = NSLocalizedString("OK", comment: "OK action title")
        let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        locationNeededAlert.addAction(OKAction)
        present(locationNeededAlert, animated: true, completion: nil)
    }
    
    private func showLocationServicesDisabledAlert() {
        
        let title = NSLocalizedString("Location Services Disabled", comment: "Title for location services disabled alert")
        let message = NSLocalizedString("Your location services are not enabled. Would you like to turn them on in settings?", comment: "Message for user location needed alert")
        let locationServicesAlert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let actionTitle = NSLocalizedString("OK", comment: "OK action title")
        let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl) { result in
                    print("Settings opened: \(result)")
                }
            }
        })
        
        let dismissTitle = NSLocalizedString("Dismiss", comment: "Dismiss action title")
        let disissAction = UIAlertAction(title: dismissTitle, style: .default, handler: nil)
        locationServicesAlert.addAction(OKAction)
        locationServicesAlert.addAction(disissAction)
        present(locationServicesAlert, animated: true, completion: nil)
    }
}
