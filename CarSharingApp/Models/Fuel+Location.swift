//
//  Fuel.swift
//  CarSharingApp
//
//  Created by gaia.magnani on 06/05/18.
//  Copyright © 2018 gaia.magnani. All rights reserved.
//

import Foundation

struct Fuel: Decodable {
    let percent: Int
    let range: Int
    let type: String
}


struct Location: Decodable {
    let lat: Double
    let lon: Double
}


