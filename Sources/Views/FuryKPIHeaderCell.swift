//
//  FuryKPIHeaderCell.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 03.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import UIKit

class FuryKPIHeaderCell: UICollectionViewCell {
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    func set(value: KPI) {
        let digits = NSCharacterSet.decimalDigits
        
        let attributedString = NSMutableAttributedString()
        for c in value.value.unicodeScalars {
            let new: NSMutableAttributedString
            if digits.contains(c) {
                let biggerFont = UIFont.systemFont(ofSize: 45, weight: UIFontWeightThin)
                new = NSMutableAttributedString(string: String(c), attributes: [NSFontAttributeName: biggerFont])
            } else {
                let smallerFont = UIFont.systemFont(ofSize: 32, weight: UIFontWeightThin)
                new = NSMutableAttributedString(string: String(c), attributes: [NSFontAttributeName: smallerFont])
            }
            attributedString.append(new)
        }
        
        mainLabel.attributedText = attributedString
        
        subtitleLabel.text = value.key
    }
}
