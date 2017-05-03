//
//  KPI.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Foundation
import RandomKit

struct KPI {
    let key: String
    let value: String
    let status: KPIStatus
}

extension KPI: Sampled {
    typealias T = KPI
    
    func formatNumber (number: Double) -> String? {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        let formattedNumberString = formatter.string(from: NSNumber(value: number))
        return formattedNumberString?.replacingOccurrences(of: ".00", with: "")
    }
    
    static func generateSamples(amount: Int) -> [KPI] {
        var randomGenerator = Xoroshiro.threadLocal.pointee
        //let energy = formatNumber(NSNumber.random(within: 0.5...100, using: &randomGenerator))
        let elements = [
            KPI(key: "Running Duration", value: "\(Int(NSNumber.random(within: 1...10000, using: &randomGenerator)))h", status: .normal),
            KPI(key: "Temperature", value: "\(Int(NSNumber.random(within: 80...150, using: &randomGenerator)))˚C", status: .normal),
            KPI(key: "Workload", value: "\(Int(NSNumber.random(using: &randomGenerator)))%", status: .normal),
            KPI(key: "Pressure", value: "\(Int(NSNumber.random(within: 80...300, using: &randomGenerator)))psi", status: .normal),
            KPI(key: "Energy consumption", value: "\(Int(NSNumber.random(within: 0.3...200, using: &randomGenerator)))kW", status: .normal)
            ].shuffled(using: &Xoroshiro.threadLocal.pointee)
        return (1...amount).map{ i in elements[i % elements.count] }
    }
    
    static func generateSample() -> KPI {
        return generateSamples(amount: 1).first!
    }
}

enum KPIStatus {
    case normal, warning, danger
}
