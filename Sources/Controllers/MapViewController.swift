//
//  DetailViewController.swift
//  sap-hack
//
//  Created by Nick Podratz on 02.05.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import UIKit
import MapKit
import TBEmptyDataSet

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    let berlinRegion = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: 52.5144, longitude: 13.4127), MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadPlacemarks()
        mapView.delegate = self
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


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "standardPin"
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        //annotationView.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "company1"))
        annotationView.canShowCallout = true
        annotationView.detailCalloutAccessoryView = UIViewController(nibName: "MapCallout", bundle: nil).view
        //annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView.image = UIImage(named: "AppIcon")
        return annotationView
    }
    
}
