//
//  TimelineCollectionViewCell.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 03.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import UIKit

class TimelineCollectionViewCell: UICollectionViewCell {
    @IBOutlet var leadingLine: UIView!
    @IBOutlet var trailingLine: UIView!
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var personImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func set(event: Event) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: event.date)
        
        switch(event.type) {
        case .comment(let person, let comment):
            titleLabel.text = "\(person.name) commented"
            loadPortrait(locatedAt: person.image)
            contentLabel.text = comment
            contentLabel.isHidden = false
        case .assignment(let person):
            icon.image = #imageLiteral(resourceName: "Inbox")
            contentLabel.isHidden = true
           loadPortrait(locatedAt: person.image)
            let bold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)]
            let firstPart = NSMutableAttributedString(string: person.name, attributes: bold)
            let secondPart = NSMutableAttributedString(string: " self-assigned this.")
            firstPart.append(secondPart)
            titleLabel.attributedText = firstPart
        default:
            contentLabel.isHidden = true
        }
        
        personImageView.layer.cornerRadius = personImageView.frame.height / 2
        personImageView.clipsToBounds = true
    }
    
    func set(position: Int, forTotal total: Int) {
            leadingLine.isHidden = (position == 0)
        trailingLine.isHidden = (position == total - 1)
    }
    
    private func loadPortrait(locatedAt urlString: String?) {
        if let urlString = urlString,
            let url = URL(string: urlString) {
            appDelegate?.cache.fetch(URL: url).onSuccess { image in
                if let data = NSData(contentsOf: url) {
                    if let image = UIImage(data: data as Data) {
                        self.personImageView.image = image
                    }
                }
            }
        }
    }
}
