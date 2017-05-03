//
//  Order.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Team Hasso. All rights reserved.
//

import Foundation
import MapKit
import RandomKit

protocol Sampled {
    associatedtype T
    static func generateSamples(amount: Int) -> [T]
    static func generateSample() -> T
}

class Order: NSObject {
    let title: String?
    let device: Device
    let creationDate: Date
    let company: Company
    
    var dueDate: Date? = nil
    var events = [Event]()
    
    public init(title: String, device: Device, creationDate: Date = Date(), company: Company) {
        self.title = title
        self.device = device
        self.creationDate = creationDate
        self.company = company
    }
}

extension Order: Sampled {
    typealias T = Order
    static func generateSamples(amount: Int) -> [Order] {
        let titles = [
            "Defect wheel",
            "Scheduled maintenance",
            "HELP plz 😵",
            "Always too loud"
            ].shuffled(using: &Xoroshiro.threadLocal.pointee)
        return (1...amount).map { i in
            return Order(title: titles[i % titles.count], device: Device.generateSample(), creationDate: Date.random(using: &Xoroshiro.threadLocal.pointee), company: Company.generateSample())
        }
    }
    
    static func generateSample() -> Order {
        return Order.generateSamples(amount: 1).first!
    }
}

extension Order: MKOverlay {
    public var coordinate: CLLocationCoordinate2D {
        return company.location
    }
    
    public var boundingMapRect: MKMapRect {
        return MKMapRect(origin: MKMapPointForCoordinate(company.location), size: MKMapSize(width: 10.0, height: 10.0))
    }
    
    public var subtitle: String? {
        return company.name
    }
}
