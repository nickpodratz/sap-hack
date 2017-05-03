//
//  Company.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import RandomKit

struct Company {
    let name: String
    let image: UIImage
    let location: CLLocationCoordinate2D
}

extension Company: Sampled {
    typealias T = Company
    static func generateSamples(amount: Int) -> [Company] {
        let companies = ["Pineapple, Inc.", "Miesens AG", "Microhard Corporation", "PAS SE", "Googolplex, Inc.", "Mapple, Inc.", "Hardware GmbH und Co. KG", "JCN", "Sanfrancisco.com", "Amazing.lol", "pH Enterprise"].shuffled(using: &Xoroshiro.threadLocal.pointee)
        var buildings = (0...10).map{ UIImage(named: "\($0)") }.filter{$0 != nil}.shuffled(using: &Xoroshiro.threadLocal.pointee)
        var location: CLLocationCoordinate2D {
            let latitude = Float.random(within: 52.4644...52.5644, using: &Xoroshiro.threadLocal.pointee)
            let longitude = Float.random(within: 13.3627...13.4627, using: &Xoroshiro.threadLocal.pointee)
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        }
        var results = [Company]()
        for i in (0..<amount) {
            let company = Company(name: companies[i % companies.count], image: buildings[i % buildings.count]!, location: location)
            print(company)
            results.append(company)
        }
        return results
    }
    
    static func generateSample() -> Company {
        return Company.generateSamples(amount: 1).first!
    }
}
