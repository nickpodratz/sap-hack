//
//  DetailViewController.swift
//  sap-hack
//
//  Created by Nick Podratz on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    let berlinRegion = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: 52.5144, longitude: 13.4127), MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadPlacemarks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        zoomToPlacemarks()
    }
    
    let orders = Order.sampleData

    func loadPlacemarks() {
        mapView.addOverlays(orders)
    }

    func zoomToPlacemarks() {
        mapView.setRegion(berlinRegion, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.mapView.showAnnotations(self.orders, animated: true)
        })
    }
}

