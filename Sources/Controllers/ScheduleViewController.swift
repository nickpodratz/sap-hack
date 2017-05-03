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
import RandomKit

class ScheduleViewController: UITableViewController {

    var mapViewController: MapViewController? = nil
    var serviceRequests = ServiceRequest.generateSamples(amount: 5).sorted(by: { $0.creationDate < $1.creationDate })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self

        tableView.register(FUITimelineCell.self, forCellReuseIdentifier: FUITimelineCell.reuseIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .backgroundBase)
        tableView.separatorStyle = .none

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            mapViewController = (controllers.last as? UINavigationController)?.topViewController as? MapViewController
        }
        tabBarController?.tabBar.items?.last?.badgeValue = "3"
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
        newRequest.isScheduled = true
        serviceRequests.insert(newRequest, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.updateEmptyDataSetIfNeeded()
        mapViewController?.addAnnotation(request: newRequest, isScheduled: true)
    }
    
    @IBAction func refreshView(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.generateServiceRequests()
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    fileprivate func generateServiceRequests() {
        let newAnnotations = ServiceRequest.generateSamples(amount: 15).sorted(by: {$0.0.dueDate! < $0.1.dueDate!})
        for newAnnotation in newAnnotations {
            newAnnotation.isScheduled = true
        }
        self.serviceRequests = newAnnotations
        self.tableView.reloadData()
        self.mapViewController?.removeAnnotations(annotationIsScheduled: true)
        self.mapViewController?.populate(requests: self.serviceRequests, scheduled: true)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let request = serviceRequests[indexPath.row]
                let navigationVC = segue.destination as! UINavigationController
                let destinationVC = navigationVC.viewControllers.first as! RequestDetailsViewController
                destinationVC.serviceRequest = request
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        var randomGenerator = Xoroshiro.threadLocal.pointee
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FUITimelineCell.reuseIdentifier, for: indexPath)
        guard let timelineCell = cell as? FUITimelineCell else { return cell }
        let request = serviceRequests[indexPath.row]
        timelineCell.timelineWidth = CGFloat(66)
        timelineCell.headlineText = request.title ?? ""
        timelineCell.subheadlineText = request.company.name //ticket.productid
        timelineCell.nodeImage = FUITimelineNode.open
        timelineCell.eventText = dateFormatter.string(from: request.dueDate!)
        timelineCell.eventImage =  #imageLiteral(resourceName: "Pin_2") // TODO: Replace with your image
        timelineCell.eventImageView.tintColor = UIColor.preferredFioriColor(forStyle: .tintColorDark)
        timelineCell.statusImage = UIImage() // TODO: Replace with your image
        //timelineCell.subStatusText =  "rainy"
        timelineCell.attributeText =  request.device.name // "1h 30 min"
        timelineCell.subAttributeText = "\(Int.random(within: 4...38, using: &Xoroshiro.defaultReseeding)) min (\(Int.random(within: 0...9, using: &Xoroshiro.defaultReseeding)).\(Int.random(within: 0...9, using: &Xoroshiro.default)) km)"
        return timelineCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
extension ScheduleViewController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Nothing to do?")
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
    
    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        let orientation = UIApplication.shared.statusBarOrientation
        return orientation.isPortrait ? -52 : -22
    }
    
    func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
        return [12, 12]
    }
}


