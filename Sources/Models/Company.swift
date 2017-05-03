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
    let image: String
    let location: CLLocationCoordinate2D
}

extension Company: Sampled {
    typealias T = Company
    static func generateSamples(amount: Int) -> [Company] {
        let buildings = [
            "http://www.loversiq.com/daut/as/f/a/architecture-adorable-futuristic-houses-amazing-modern-style-excerpt-house-design_futuristic-house-interior-architecture_interior-design_interior-design-schools-school-designer-tips-modern-books-best-.jpg",
            "https://www.l-seifert.de/bilder-technik/Fabrik.jpg",
            "http://meine.seestadt.info/wp-content/uploads/2014/07/P5230145-1024x768.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/9/93/Berlin%2C_Kreuzberg%2C_Koepenicker_Strasse_20%2C_Berliner_Velvet-Fabrik.jpg",
            "http://www.geo.de/reisen/community/bild/regular/486242/Fabrik-am-Mississippi.jpg",
            "http://www.braugasthof-fabrik.at/wp-content/uploads/2015/01/fabrik_front_full2.jpg",
            "http://img.shz.de/img/landeszeitung/crop16657321/8726396502-cv16_9-w596/23-88344914-23-88344915-1493030553.jpg"
        ].shuffled(using: &Xoroshiro.threadLocal.pointee)
        let companies = ["Pineapple, Inc.", "Miesens AG", "Microhard, Inc.", "PAS AG", "Googolplex, Inc.", "Mapple, Inc."].shuffled(using: &Xoroshiro.threadLocal.pointee)
        var location: CLLocationCoordinate2D {
            let latitude = Float.random(within: 52...53, using: &Xoroshiro.threadLocal.pointee)
            let longitude = Float.random(within: 12...13, using: &Xoroshiro.threadLocal.pointee)
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        }
        return (1...amount).map { i in
            return Company(name: companies[i % companies.count], image: buildings[i % companies.count], location: location)
        }
    }
    
    static func generateSample() -> Company {
        return Company.generateSamples(amount: 1).first!
    }
}
