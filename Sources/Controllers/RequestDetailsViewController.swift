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
        
        loadPortrait(locatedAt: serviceRequest.requester.image)
        requesterNameLabel.text = serviceRequest.requester.name
        requesterCompanyLabel.text = serviceRequest.company.name
    }
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var eventsCollectionView: UICollectionView!
    
    @IBOutlet var requesterImageView: UIImageView!
    @IBOutlet var requesterNameLabel: UILabel!
    @IBOutlet var requesterCompanyLabel: UILabel!
    
    private func loadPortrait(locatedAt urlString: String?) {
        if let urlString = urlString,
            let url = URL(string: urlString) {
            appDelegate?.cache.fetch(URL: url).onSuccess { image in
                if let data = NSData(contentsOf: url) {
                    if let image = UIImage(data: data as Data) {
                        self.requesterImageView.image = image
                        self.requesterImageView.layer.cornerRadius = self.requesterImageView.bounds.width/2
                        self.requesterImageView.clipsToBounds = true
                    }
                }
            }
        }
    }
    
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


