//
//  Order.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Team Hasso. All rights reserved.
//

import Foundation
import MapKit

class Order: NSObject {
    let title: String?
    let device: Device
    let creationDate: Date
    let location: CLLocationCoordinate2D
    let requester: Company
    
    var dueDate: Date? = nil
    var events = [Event]()
    
    public init(title: String, device: Device, creationDate: Date = Date(), location: CLLocationCoordinate2D, requester: Company) {
        self.title = title
        self.device = device
        self.creationDate = creationDate
        self.location = location
        self.requester = requester
    }
}

extension Order: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return location
    }
    
    public var subtitle: String? {
        return requester.name
    }
}
