//
//  ViewController.swift
//  Project22
//
//  Created by Weirup, Chris on 2019-05-18.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var beaconInRangeLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var activeBeacon: UUID?
    let shapeLayer = CAShapeLayer()
    var taps = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        self.beaconInRangeLabel.text = "No beacon found"
        
        let center = view.center
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: (CGFloat.pi * 2.0) - (CGFloat.pi / 2), clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func updateDistanceIndicator(toAmount: Float) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

        basicAnimation.fromValue = Float(shapeLayer.presentation()!.strokeEnd)
        basicAnimation.toValue = toAmount
        basicAnimation.duration = 0.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid1 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let uuid2 = UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!
        let uuid3 = UUID(uuidString: "5AFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF")!
        
        // FOR TESTING
        // mbeacon -uuid "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5" -major 123 -minor 456
        // mbeacon -uuid "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6" -major 555 -minor 111
        // mbeacon -uuid "5AFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF" -major 123 -minor 987
        
        let beaconRegion1 = CLBeaconRegion(proximityUUID: uuid1, major: 123, minor: 456, identifier: "MyBeacon")
        let beaconRegion2 = CLBeaconRegion(proximityUUID: uuid2, major: 555, minor: 111, identifier: "RadiusBeacon")
        let beaconRegion3 = CLBeaconRegion(proximityUUID: uuid3, major: 123, minor: 987, identifier: "RedBearBeacon")
        
        let beaconRegions = [beaconRegion1, beaconRegion2, beaconRegion3]
        
        for region in beaconRegions {
            locationManager?.startMonitoring(for: region)
            locationManager?.startRangingBeacons(in: region)
        }
    }
    
    func update(id: String, distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            self.beaconInRangeLabel.text = id
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.updateDistanceIndicator(toAmount: 0.25)
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.updateDistanceIndicator(toAmount: 0.50)
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.updateDistanceIndicator(toAmount: 1.00)
            default:
                self.beaconInRangeLabel.text = "No beacon found"
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.updateDistanceIndicator(toAmount: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if beacon.proximityUUID != activeBeacon {
                activeBeacon = beacon.proximityUUID
                let ac = UIAlertController(title: "New Beacon Found", message: "We found beacon \(activeBeacon!.uuidString)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                present(ac, animated: true)
            }
            
            update(id: beacon.proximityUUID.uuidString, distance: beacon.proximity)
        }
    }

}

