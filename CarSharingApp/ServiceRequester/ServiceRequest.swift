//
//  ServiceRequest.swift
//  CarSharingApp
//
//  Created by gaia.magnani on 05/05/18.
//  Copyright © 2018 gaia.magnani. All rights reserved.
//

import Foundation

class ServiceRequest {
    
    var vehicles: [Vehicle]?
    init() {}
    
    func makeRequest(completionHandler :  @escaping () -> Void,
                     errCompletionHandler :  ( (String) -> Void )?){
        
        let urlStr: String = ""
        let url = NSURL(string: urlStr)!
        
        let config = URLSessionConfiguration.default
        
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "x-api-key": "Nv3day0hzV3GZ0JceINKM8LxYfcQc0k346paK8L7"
        ]
        
        let urlSession = URLSession(configuration: config)
        
        let myQuery = urlSession.dataTask(with: url as URL, completionHandler: {
            data, response, error -> Void in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            guard let responseModel = VehicleResponseModelBuilder.modelFrom(data!), let vehicles = responseModel.vehicles else {
                errCompletionHandler!("parse error")
                return
            }
            self.vehicles = vehicles
            completionHandler()
            
        })
        myQuery.resume()
    }
}
