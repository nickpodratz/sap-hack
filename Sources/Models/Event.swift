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
    let type: EventType
    let date: Date
}

enum EventType {
    case assignment(Person)
    case comment(Person, String)
    case telemetry(Device, String)
}

extension Event {
    typealias T = Event
    static func conversation(about device: Device) -> [T] {
        let people = Person.generateSamples(amount: 3)
        let elements = [
            Event(type: .telemetry(device, "Status: \(device.kpi[0].key) is \(device.kpi[0].value)"), date: Date.random(using: &Xoroshiro.threadLocal.pointee)),
            Event(type: .comment(people[0], "I think we need to order some replacement materials before we can work on this."), date: Date.random(using: &Xoroshiro.threadLocal.pointee)),
            Event(type: .assignment(people[0]), date: Date.random(using: &Xoroshiro.threadLocal.pointee)),
            Event(type: .comment(people[1], "I found I found the right replacement parts in our inventory! I'll check with \(people[2].name)."), date: Date.random(using: &Xoroshiro.threadLocal.pointee)),
            Event(type: .comment(people[2], "Yes, that's alright."), date: Date.random(using: &Xoroshiro.threadLocal.pointee)),
            Event(type: .comment(people[0], "Okay, all done here"), date: Date.random(using: &Xoroshiro.threadLocal.pointee))
            ]
        return elements
    }
}
