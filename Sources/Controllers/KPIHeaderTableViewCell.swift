//
//  KPIHeaderTableViewCell.swift
//  sap-hack
//
//  Created by Carl Julius Gödecken on 03.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import UIKit

class KPIHeaderTableViewCell: UITableViewCell {
    
    var device: Device!
    @IBOutlet var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension KPIHeaderTableViewCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return device.kpi.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FuryKPIHeaderCell
        let kpi = device.kpi[indexPath.row]
        cell.set(value: kpi)
        
        return cell
    }
}
