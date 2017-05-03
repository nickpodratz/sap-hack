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
    static func generateSamples(amount: Int) -> [KPI] {
        let elements = [
            KPI(key: "Running Duration", value: "16h", status: .normal),
            KPI(key: "Running Duration", value: "11h", status: .normal),
            KPI(key: "Running Duration", value: "23h", status: .normal),
            KPI(key: "Temperature", value: "74˚C", status: .normal),
            KPI(key: "Temperature", value: "126˚C", status: .warning),
            KPI(key: "Workload", value: "26%", status: .normal),
            KPI(key: "Workload", value: "51%", status: .normal),
            KPI(key: "Workload", value: "84%", status: .normal),
            KPI(key: "Workload", value: "16h", status: .normal),
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
