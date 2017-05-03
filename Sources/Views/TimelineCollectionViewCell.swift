//
//  TimelineCollectionViewCell.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 03.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import UIKit
import SAPFiori

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
        
        let formattedString = NSMutableAttributedString()
        switch(event.type) {
        case .comment(let person, let comment):
            icon.image = FUITimelineNode.open
            titleLabel.attributedText = formattedString
                .bold(person.name)
                .normal(" commented")
            loadPortrait(locatedAt: person.image)
            contentLabel.text = comment
            contentLabel.isHidden = false
            
        case .assignment(let person):
            icon.image = FUITimelineNode.start
            contentLabel.isHidden = true
           loadPortrait(locatedAt: person.image)
            titleLabel.attributedText = formattedString
                .bold(person.name)
                .normal(" self-assigned this")
            
        case .telemetry(let device, let message):
            icon.image = FUITimelineNode.inactive
            titleLabel.attributedText = formattedString
                .bold(device.name)
                .normal(" has uploaded telemetry")
            loadPortrait(locatedAt: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/2_komponenten_einfachdosierer_auf_portal.jpg/800px-2_komponenten_einfachdosierer_auf_portal.jpg")
            contentLabel.text = message
        
        case .intervention(let person, let message):
            icon.image = FUITimelineNode.complete
            titleLabel.attributedText = formattedString
                .bold(person.name)
                .normal(" performed a ")
                .bold("repair")
            loadPortrait(locatedAt: person.image)
            contentLabel.text = message
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
