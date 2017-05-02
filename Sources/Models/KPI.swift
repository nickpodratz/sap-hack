//
//  KPI.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Foundation

struct KPI {
    let key: String
    let value: String
    let status: KPIStatus
}

enum KPIStatus {
    case normal, warning, danger
}
