//
//  Event.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Foundation
import UIKit

struct Event {
    let title: String
    let type: EventType
    
    var description: NSAttributedString {
        switch(type) {
        case .assignment(let person):
            let bold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)]
            let firstPart = NSMutableAttributedString(string: person.name, attributes: bold)
            let secondPart = NSMutableAttributedString(string: " self-assigned this.")
            firstPart.append(secondPart)
            return firstPart
        case .comment(let person, let comment):
            let string = "\(person) commented: \(comment)"
            return NSAttributedString(string: string)
        }
    }
}

enum EventType {
    case assignment(Person)
    case comment(Person, String)
}
