//
//  ChatViewController.swift
//  sap-hack
//
//  Created by Johannes Unruh on 03.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

//  SAP Fiori for iOS Mentor
//  SAP Cloud Platform SDK for iOS Code Example
//  Timeline Cell
//  Copyright © 2017 SAP SE or an SAP affiliate company. All rights reserved.



import UIKit
import SAPFiori


class ChatViewController: UITableViewController {
    
    let serviceHistory =
        [["Your conversation with Melanie started", "", "10:23 AM", "", ""],
         ["When will we be able to use the CXC300 again?", "Charlies Schokoladenfabirk", "10:25 AM", "Melanie Schaffer", "8 min"],
        ["The service it self will take about 8 min. I will be on site in an hour.", "", "10:29 AM", "you", ""],
        ["Can you let me know if the fuse X2 is blown?", "", "12:12 AM", "", ""],
        ["Yes it is, i hope that helps. Thank you, see you then", "Charlies Schokoladenfabrik", "10:42 AM", "Melanie Schaffer", "8 min"],
        ["Your conversation with Melanie has ended", "", "12:12 AM", "", ""]]
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let cellReuseIdentifierMiddle = "FUITimelineCell"
    let cellReuseIdentifierStart = "FUITimelineMarkerCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FUITimelineCell.self, forCellReuseIdentifier: FUITimelineCell.reuseIdentifier)
        tableView.register(FUITimelineMarkerCell.self, forCellReuseIdentifier: FUITimelineMarkerCell.reuseIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.preferredFioriColor(forStyle: .backgroundBase)
        tableView.separatorStyle = .none
    }
    
    // Table delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceHistory.count
    }
    @IBAction func refreshView(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let serviceHistoryAtIndex = self.serviceHistory[indexPath.row]
        
        let cellReusableIdentifier: String
        if indexPath.row == 0 || indexPath.row == serviceHistory.count-1 || serviceHistoryAtIndex[1] == "" {
            cellReusableIdentifier = "FUITimelineMarkerCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FUITimelineMarkerCell.reuseIdentifier, for: indexPath)
            guard let timelineCell = cell as? FUITimelineMarkerCell else {
                return cell
            }
            
            timelineCell.timelineWidth = CGFloat(95.0)
            timelineCell.eventText = serviceHistoryAtIndex[2]
            timelineCell.titleText = serviceHistoryAtIndex[0]
            
            if indexPath.row == 0 {
                timelineCell.nodeImage = FUITimelineNode.start
            } else if indexPath.row == serviceHistory.count-1 {
                timelineCell.nodeImage = FUITimelineNode.end
                timelineCell.showTrailingTimeline = false
            } else if serviceHistoryAtIndex[1] == "" {
                timelineCell.nodeImage = FUITimelineNode.inactive
            }
        
            return cell
        } else {
            cellReusableIdentifier = "FUITimelineCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FUITimelineCell.reuseIdentifier, for: indexPath)
            guard let timelineCell = cell as? FUITimelineCell else {
                return cell
            }
            
            timelineCell.timelineWidth = CGFloat(95.0)
            timelineCell.headlineText = serviceHistoryAtIndex[0]
            timelineCell.subheadlineText = serviceHistoryAtIndex[1]
            timelineCell.nodeImage = FUITimelineNode.open
            timelineCell.eventText =  serviceHistoryAtIndex[2]
            timelineCell.eventImage =  UIImage() // TODO: Replace with your image
            timelineCell.statusImage = UIImage() // TODO: Replace with your image
            timelineCell.attributeText =  serviceHistoryAtIndex[3]
            timelineCell.subAttributeText =  serviceHistoryAtIndex[4]
            return cell
        }
        
        
    }
}


