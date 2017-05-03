//
//  MasterViewController.swift
//  sap-hack
//
//  Created by Nick Podratz on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import UIKit
import TBEmptyDataSet
import SAPFiori
import Haneke

class RequestsViewController: UITableViewController {

    var mapViewController: MapViewController? = nil
    var serviceRequests = ServiceRequest.generateSamples(amount: 3) {
        didSet {
            tabBarController?.tabBar.items?.last?.badgeValue = serviceRequests.count == 0 ? nil : "\(serviceRequests.count)"
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .backgroundBase)
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            mapViewController = (controllers.last as? UINavigationController)?.topViewController as? MapViewController
        }
        mapViewController?.populate(requests: self.serviceRequests, scheduled: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        let newRequest = ServiceRequest.generateSample()
        serviceRequests.insert(newRequest, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.updateEmptyDataSetIfNeeded()
        mapViewController?.addAnnotation(request: newRequest, isScheduled: false)
    }
    
    @IBAction func refreshView(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.generateServiceRequests()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    fileprivate func generateServiceRequests() {
        self.serviceRequests = ServiceRequest.generateSamples(amount: 15)
        self.tableView.reloadData()
        self.mapViewController?.removeAnnotations(annotationIsScheduled: false)
        self.mapViewController?.populate(requests: self.serviceRequests, scheduled: false)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let serviceRequest = serviceRequests[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! RequestDetailsViewController
                controller.serviceRequest = serviceRequest
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceRequests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath)
        guard let tableViewCell = cell as? FUIObjectTableViewCell else { return cell }

        let serviceRequest = serviceRequests[indexPath.row]
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let url = URL(string: serviceRequest.company.image) {
            appDelegate?.cache.fetch(URL: url).onSuccess { image in
                if let data = NSData(contentsOf: url) {
                    if let image = UIImage(data: data as Data) {
                        tableViewCell.detailImage = image
                        tableViewCell.detailImageView.layer.cornerRadius = tableViewCell.detailImageView.bounds.width/2
                    }
                }
            }
        }
        tableViewCell.headlineText = serviceRequest.title
        tableViewCell.subheadlineText = serviceRequest.subtitle
        tableViewCell.footnoteText = serviceRequest.device.name
        tableViewCell.imageView?.image = UIImage()
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mapViewController?.removeAnnotation(request: serviceRequests[indexPath.row])
            serviceRequests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        tableView.updateEmptyDataSetIfNeeded()
    }


}


// MARK: : TBEmptyDataSetDelegate, TBEmptyDataSetDataSource
extension RequestsViewController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No open requests!")
    }
    
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "¯\\_(ツ)_/¯")
    }

    func emptyDataSetDidTapEmptyView(in scrollView: UIScrollView) {
        generateServiceRequests()
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



