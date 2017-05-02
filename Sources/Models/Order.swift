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
    
    static func generateSampleData() -> [Order] {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        // devices
        let dmgMoriClx350 = Device(name: "CLX 350", kpi: [])
        let lasertec1 = Device(name: "LASERTEC 20 PrecisionTool", kpi: [
            KPI(key: "lens temperature", value: "125 °C", status: .danger)
        ])
        let kukaLbr = Device(name: "KUKA LBR iiwa", kpi: [])
        let kukaKr = Device(name: "KUKA KR 210-2 F exclusive", kpi: [])
        let momCorp1X = Device(name: "MomCorp Robot 1-X", kpi: [])
        
        // companies
        let miesens = Company(name: "Miesens AG", image: nil, location: CLLocationCoordinate2D(latitude: 52.5380, longitude: 13.2631))
        let mapple = Company(name: "Mapple, Inc.", image: nil, location: CLLocationCoordinate2D(latitude: 52.5035, longitude: 13.3288))
        
        let orders = [
            Order(title: "Defekt bei Drehmaschine", device: dmgMoriClx350, location: miesens.location!, requester: miesens),
            Order(title: "Geplante Wartung", device: dmgMoriClx350, location: miesens.location!, requester: miesens),
            Order(title: "HALP plz 😵", device: momCorp1X, creationDate: yesterday, location: mapple.location!, requester: mapple)
        ]
        return orders
    }
    
    static var sampleData: [Order] = Order.generateSampleData()
}

extension Order: MKOverlay {
    public var coordinate: CLLocationCoordinate2D {
        return location
    }
    
    public var subtitle: String? {
        return requester.name
    }
}
