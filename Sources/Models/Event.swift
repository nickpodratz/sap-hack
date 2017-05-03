//
//  Event.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Foundation
import UIKit
import RandomKit

struct Event {
    let title: String
    let type: EventType
    let date: Date
}

enum EventType {
    case assignment(Person)
    case comment(Person, String)
}

extension Event: Sampled {
    typealias T = Event
    static func generateSamples(amount: Int) -> [T] {
        let elements = [
            Event(title: "", type: .assignment(Person.generateSample()), date: Date.random(using: &Xoroshiro.threadLocal.pointee)),
            Event(title: "", type: .comment(Person.generateSample(), "I don't think we should do this"), date: Date.random(using: &Xoroshiro.threadLocal.pointee)),
            Event(title: "", type: .comment(Person.generateSample(), "Wow, great stuff!"), date: Date.random(using: &Xoroshiro.threadLocal.pointee))
            ].shuffled(using: &Xoroshiro.threadLocal.pointee)
        return (1...amount).map{ i in elements[i % elements.count] }
    }
    
    static func generateSample() -> T {
        return generateSamples(amount: 1).first!
    }
}
