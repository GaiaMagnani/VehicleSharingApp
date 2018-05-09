//
//  Vehicle.swift
//  CarSharingApp
//
//  Created by gaia.magnani on 05/05/18.
//  Copyright © 2018 gaia.magnani. All rights reserved.
//

import Foundation
import MapKit

enum VehicleResponseModelKeys: String {
    case vehicles
    case location
}

protocol VehicleResponseModelProtocol {
    var vehicles: [Vehicle]? { get }
    var location: String { get }
}


class VehicleResponseModelBuilder {
    
    static func modelFrom(_ responseData: Data) -> VehicleResponseModelProtocol? {
        
        return try? JSONDecoder().decode(DecodableVehicleResponseModel.self, from: responseData)
        
    }
}
extension VehicleResponseModelKeys: CodingKey{
}


struct DecodableVehicleResponseModel: Decodable, VehicleResponseModelProtocol {
    var vehicles: [Vehicle]?
    var location: String
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: VehicleResponseModelKeys.self)
        self.location = try values.decode(String.self, forKey: .location)
        self.vehicles = try values.decode([Vehicle].self, forKey: .vehicles)
    }
}

enum VehicleKeys: String {
    case fuel
    case location
    case model
    case pinUrl
    case provider
    case type
}

protocol VehicleProtocol {
    var fuel: Fuel { get }
    var coordinate: CLLocationCoordinate2D { get }
    var model: String { get }
    var pinUrl: String { get }
    var title: String? { get }
    var subtitle: String? { get }
    
}

extension VehicleKeys: CodingKey{
}

class Vehicle: NSObject, Decodable, VehicleProtocol, MKAnnotation {
    
    let fuel : Fuel
    let coordinate: CLLocationCoordinate2D
    let model: String
    let pinUrl: String
    let title: String?
    let subtitle: String?
    let location: CLLocation?
    var distance: CLLocationDistance?

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: VehicleKeys.self)
        self.fuel = try values.decode(Fuel.self, forKey: .fuel)
        self.model = try values.decode(String.self, forKey: .model)
        self.pinUrl = try values.decode(String.self, forKey: .pinUrl)
        let locationModel = try values.decode(Location.self, forKey: .location)
        self.coordinate = CLLocationCoordinate2D(latitude: locationModel.lat, longitude: locationModel.lon)
        self.title = try values.decode(String.self, forKey: .provider)
        self.subtitle = try values.decode(String.self, forKey: .type)
        self.location = CLLocation(latitude: locationModel.lat, longitude: locationModel.lon)
        self.distance = nil
    }
}

