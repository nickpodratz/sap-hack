//
//  MasterViewController.swift
//  sap-hack
//
//  Created by Nick Podratz on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import UIKit
import SAPFiori
import TBEmptyDataSet

class RequestDetailsViewController: UITableViewController {

    var serviceRequest: ServiceRequest!
    
    enum cellTypes: String {
        case kpiHeader
    }    
    
    @IBOutlet var kpiHeader: KPIHeaderTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kpiHeader.device = serviceRequest.device
        if let navBar = self.navigationController?.navigationBar {
            let shadowView = shadowImageViewInNavigationBar(view: navBar)
            shadowView?.layer.isHidden = true
        }
        eventsCollectionView.dataSource = self
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var eventsCollectionView: UICollectionView!
}

// MARK: : TBEmptyDataSetDelegate, TBEmptyDataSetDataSource
extension RequestDetailsViewController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "There are no details for this request.")
    }
    
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "¯\\_(ツ)_/¯")
    }
    
    func emptyDataSetWillAppear(in scrollView: UIScrollView) {
        tableView.separatorStyle = .none
    }
    
    func emptyDataSetDidDisappear(in scrollView: UIScrollView) {
        tableView.separatorStyle = .singleLine
    }
    
    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        let orientation = UIApplication.shared.statusBarOrientation
        return orientation.isPortrait ? -52 : -22
    }
    
    func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
        return [12, 12]
    }
}

private func shadowImageViewInNavigationBar(view: UIView) -> UIImageView? {
    if view is UIImageView && view.bounds.height <= 1.0 {
        return (view as! UIImageView)
    }
    
    let subviews = (view.subviews as [UIView])
    for subview: UIView in subviews {
        if let imageView: UIImageView = shadowImageViewInNavigationBar(view: subview) {
            return imageView
        }
    }
    return nil
}
extension RequestDetailsViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceRequest.events.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! TimelineCollectionViewCell
        let event = serviceRequest.events[indexPath.row]
        cell.set(event: event)
        cell.set(position: indexPath.row, forTotal: serviceRequest.events.count)
        return cell
    }
}


