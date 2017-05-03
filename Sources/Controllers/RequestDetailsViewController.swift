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

    var order: Order!
    
    enum cellTypes: String {
        case kpiHeader
    }
    
    
    @IBOutlet var kpiHeader: KPIHeaderTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kpiHeader.device = order.device
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: : TBEmptyDataSetDelegate, TBEmptyDataSetDataSource
extension RequestDetailsViewController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "There are no details for this request.")
    }
    
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "… weird, isn't it?")
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


