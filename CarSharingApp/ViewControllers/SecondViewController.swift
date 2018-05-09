//
//  SecondViewController.swift
//  CarSharingApp
//
//  Created by gaia.magnani on 05/05/18.
//  Copyright © 2018 gaia.magnani. All rights reserved.
//

import UIKit
import MapKit
 
struct CellData {
    let image : UIImage?
    let message : String?
}

class SecondViewController: UIViewController {
    
    var userLocation: CLLocation!
    var locationManager: CLLocationManager!
    var vehicles: [Vehicle]?
    var data = [CellData]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        startRequest()
    }

    func startRequest() {
        let serviceRequester = ServiceRequest()
        let completionHandler = {
            if let vehicles = serviceRequester.vehicles {
                
                let vehiclesWithDistance = vehicles.map({ ( vehicle ) -> Vehicle in
                    guard let location = vehicle.location else {
                        return vehicle
                    }
                    if let userLoc = self.locationManager.location {
                        vehicle.distance = location.distance(from: userLoc)
                    }
                    return vehicle
                })
                
                self.vehicles = vehiclesWithDistance.sorted(by: { (v, v2) -> Bool in
                    v.distance! < v2.distance!
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        let errCompletionHandler = {
            (error: String) -> Void in
            print("\(error) ERROR getting data from API")
        }
        
        serviceRequester.makeRequest(completionHandler: completionHandler, errCompletionHandler: errCompletionHandler)
    }
}

extension SecondViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        self.userLocation = location
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let numberOfVehicles = vehicles?.count else {
            return 0
        }
        return numberOfVehicles
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "vehicleCellIdentifier", for: indexPath) as? VehicleTableViewCell
        
        if let v = self.vehicles?[indexPath.row] {
            cell?.name.text = v.model
            if let distance = v.distance {
                let km = distance / 1000
                cell?.distance.text = "Distanza: " + km.rounded().description + " Km"
            }
            if let imageName = v.title {
                cell?.imageView?.image = UIImage(named: imageName)
            }
            cell?.fuel.text = "Livello carburante: " + v.fuel.percent.description + "%"
        }
        
        return cell!
    }
}


