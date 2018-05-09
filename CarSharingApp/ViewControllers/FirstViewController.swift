//
//  FirstViewController.swift
//  CarSharingApp
//
//  Created by gaia.magnani on 05/05/18.
//  Copyright © 2018 gaia.magnani. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D!
    var vehicles: [Vehicle]?
    var serviceTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startRequest()
        serviceTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(startRequest), userInfo: nil, repeats: true)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }
    
    @objc func startRequest() {
        let serviceRequester = ServiceRequest()
        let completionHandler = {
            if let vehicles = serviceRequester.vehicles {
                self.vehicles = vehicles
                for v in self.vehicles! {
                    self.mapView.addAnnotation(v)
                }
            }
        }
        let errCompletionHandler = {
            (error: String) -> Void in
            print("\(error) ERROR getting data from API")
        }
        print(#function)
        serviceRequester.makeRequest(completionHandler: completionHandler, errCompletionHandler: errCompletionHandler)
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userLocation = userLocation.coordinate
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: self.userLocation, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
}

extension FirstViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Vehicle else { return nil }
        let identifier = "marker"
        var view: VehicleAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? VehicleAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = VehicleAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            let url = URL(string: annotation.pinUrl)
            let uiimage = UIImageView()
            let placeholderPin = UIImage(named: "pin")
            uiimage.kf.setImage(with: url, placeholder: placeholderPin, options: [.fromMemoryCacheOrRefresh], progressBlock: nil, completionHandler: nil)
            view.image = uiimage.image
        }
        return view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        serviceTimer.invalidate()
    }
}

