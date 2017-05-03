//
//  Device.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Foundation
import RandomKit

struct Device {
    let name: String
    let kpi: [KPI]
}

extension Device: Sampled {
    typealias T = Device
    static func generateSamples(amount: Int) -> [Device] {
        let machines = ["Machinero 5000", "Suriname20k", "Itaro30", "Musakumo 16", "L19", "Karu", "Maduro", "Kalinga"].shuffled(using: &Xoroshiro.threadLocal.pointee)
        return (0..<amount).map{ i in
            return Device(name: machines[machines.count % i], kpi: KPI.generateSamples(amount: 1))
        }
    }
    
    static func generateSample() -> Device {
        return Device.generateSamples(amount: 1).first!
    }
}
