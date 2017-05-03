//
//  NSAttributedString+.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 03.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
