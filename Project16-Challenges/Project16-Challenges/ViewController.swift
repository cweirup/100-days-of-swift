//
//  ViewController.swift
//  Project16
//
//  Created by Weirup, Chris on 2019-04-23.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMapView))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home of the 2012 Summer Olympics", wikiEntry: "London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "It was founded over one thousand years ago.", wikiEntry: "Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", wikiEntry: "Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside of it.", wikiEntry: "Rome")
        let washington = Capital(title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", wikiEntry: "Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.pinTintColor = UIColor.init(red: 0.16, green: 0.5, blue: 0.00, alpha: 1)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let vc = DetailViewController()
        vc.capital = capital
        navigationController?.pushViewController(vc, animated: true)
        
//        let placeName = capital.title
//        let placeInfo = capital.info
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(ac, animated: true)
    }
    
    @objc func changeMapView() {
        let ac = UIAlertController(title: "Map View", message: "Which map view would you like?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { _ in
            self.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { _ in
            self.mapView.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { _ in
            self.mapView.mapType = .hybrid
        })
        present(ac, animated: true)
    }

}

