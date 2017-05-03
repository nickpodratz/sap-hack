//
//  Person.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Foundation
import RandomKit


struct Person {
    let name: String
    var company: Company? = nil
    let image: String?
}

extension Person: Sampled {
    typealias T = Person
    static func generateSamples(amount: Int) -> [Person] {
        let elements = [
            Person(name: "Bessie Chambers", company: nil, image: "https://randomuser.me/api/portraits/women/42.jpg"),
            Person(name: "Chad Reyes", company: nil, image: "https://randomuser.me/api/portraits/men/17.jpg"),
            Person(name: "Nina Ray", company: nil, image: "https://randomuser.me/api/portraits/women/94.jpg"),
            Person(name: "Dolores Taylor", company: nil, image: "https://randomuser.me/api/portraits/women/25.jpg"),
            Person(name: "Jeremiah Harper", company: nil, image: "https://randomuser.me/api/portraits/men/59.jpg")
            ].shuffled(using: &Xoroshiro.threadLocal.pointee)
        return (1...amount).map{ i in elements[i % elements.count] }
    }
    
    static func generateSample() -> Person {
        return generateSamples(amount: 1).first!
    }
}
