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
        var buildings = [
            "https://www.l-seifert.de/bilder-technik/Fabrik.jpg",
            "https://cdn.pixabay.com/photo/2013/11/06/12/50/wurzburg-206414_960_720.jpg",
            "http://st.depositphotos.com/1027855/1941/i/950/depositphotos_19415923-stock-photo-the-factory-crane.jpg",
            "http://www.geo.de/reisen/community/bild/regular/597192/Restaurant-Ziegel-au-Lac-in-der-Rote-Fabrik.jpg",
            "https://media-cdn.holidaycheck.com/w_1280,h_720,c_fill,q_80/ugc/images/07facd89-eea1-3e06-86e8-5966a8ad899d",
            "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTyiCGSdaBFzclGQD4fjFs6iAtCeyrSzmQNGKB12qD-0VCUHObQ7A",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgxLZJ0QBWJ42YRDaTtjK3H733Xe82mPB1GXYvfePUFqTuOfo2",
            "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTO7-bhBZFq9JGEqMkTgAYdntgLFoD2j6paab8-QN8B9N_bNLiEAQ",
            "http://gallery.aavy.de/65-thickbox_default/investment-fuer-bautraeger-fabrik-loft-in-spremberg.jpg",
            "http://images.china.cn/attachement/jpg/site1003/20111018/001fd04cfc9010078d9e5b.jpg",
            "http://files.newsnetz.ch/story/2/2/7/22760527/19/topelement.jpg",
            ].shuffled(using: &Xoroshiro.threadLocal.pointee)
        let companies = ["Pineapple, Inc.", "Miesens AG", "Microhard, Inc.", "PAS AG", "Googolplex, Inc.", "Mapple, Inc."].shuffled(using: &Xoroshiro.threadLocal.pointee)
        var location: CLLocationCoordinate2D {
            let latitude = Float.random(within: 52.4644...52.5644, using: &Xoroshiro.threadLocal.pointee)
            let longitude = Float.random(within: 13.3627...13.4627, using: &Xoroshiro.threadLocal.pointee)
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        }
        var results = [Company]()
        for i in (0..<amount) {
            let company = Company(name: companies[i % companies.count], image: buildings[i % buildings.count], location: location)
            print(company)
            results.append(company)
        }
        return results
    }
    
    static func generateSample() -> Company {
        return Company.generateSamples(amount: 1).first!
    }
}
