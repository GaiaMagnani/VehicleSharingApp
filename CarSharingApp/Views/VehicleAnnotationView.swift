//
//  VehicleAnnotationView.swift
//  CarSharingApp
//
//  Created by gaia.magnani on 07/05/18.
//  Copyright © 2018 gaia.magnani. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class VehicleAnnotationView: MKAnnotationView {
    
    weak var customCalloutView: CustomAnnotationView?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = UIImage(named: "pin")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false 
        self.image = UIImage(named: "pin")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else {
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else { return nil }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.customCalloutView?.removeFromSuperview()
            
            if let newCustomCalloutView = loadMapView() {
                
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: 1, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else {
            
            if customCalloutView != nil {
                if animated {
                    UIView.animate(withDuration: 1, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() }
            }
        }
    }
    
    func loadMapView() -> CustomAnnotationView? {
        if let view = Bundle.main.loadNibNamed("CustomAnnotationView", owner: self, options: nil) as? [CustomAnnotationView], view.count > 0 {
            let detailMapView = view.first!
            if let v = annotation as? Vehicle {
                
                let ceo: CLGeocoder = CLGeocoder()
                if let loc = v.location {
                    ceo.reverseGeocodeLocation(loc, completionHandler:
                        {(placemarks, error) in
                            if (error != nil) {
                                print("reverse geodcode fail: \(error!.localizedDescription)")
                            }
                            let pm = placemarks! as [CLPlacemark]
                            
                            if pm.count > 0 {
                                let pm = placemarks![0]
                                var addressString : String = ""
                                if pm.subLocality != nil {
                                    addressString = addressString + pm.subLocality! + ", "
                                }
                                if pm.thoroughfare != nil {
                                    addressString = addressString + pm.thoroughfare! + ", "
                                }
                                if pm.locality != nil {
                                    addressString = addressString + pm.locality! + ", "
                                }
                                if pm.country != nil {
                                    addressString = addressString + pm.country! + ", "
                                }
                                if pm.postalCode != nil {
                                    addressString = addressString + pm.postalCode! + " "
                                }
                                detailMapView.address.text = addressString
                                
                            }
                            
                            detailMapView.modelLabel.text = v.model
                            
                            if let imgName = v.title {
                                detailMapView.img.image = UIImage(named: imgName)
                            }
                            
                            detailMapView.fuelLabel.text = v.fuel.percent.description + "%"
                    })
                }
            }
            return detailMapView
        }
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}
