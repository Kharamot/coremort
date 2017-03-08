//
//  ViewController.swift
//  coremort
//
//  Created by Kameron Haramoto on 3/7/17.
//  Copyright © 2017 Kameron Haramoto. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var yawLAbel: UILabel!
    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var lattitudeLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    map.usertackingmode = .follow
    var motionManager: CMMotionManager!
    
    func initializeMotion() { // called from start up method 
        self.motionManager = CMMotionManager()
        self.motionManager.deviceMotionUpdateInterval = 0.1 // secs
    }
    
    func startMotion () {
        self.motionManager.startDeviceMotionUpdates(
            to: OperationQueue.current!, withHandler: motionHandler)
    }
    
    func stopMotion () {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    func motionHandler (deviceMotion: CMDeviceMotion?, error: Error?) {
        if let err = error {
            NSLog("motionHandler error: \(err.localizedDescription)")
        } else {
            if let dm = deviceMotion {
                //Do Something
                let yaw = dm.attitude.yaw
                let pitch = dm.attitude.pitch
                let roll = dm.attitude.roll
                self.yawLAbel.text = "Yaw: \(yaw)"
                self.pitchLabel.text = "Pitch: \(pitch)"
                self.rollLabel.text = "Roll: \(roll)"
                
            } else {
                NSLog("motionHandler: deviceMotion = nil")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeMotion()
        self.initializeLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startMotion()
        let status = CLLocationManager.authorizationStatus()
        if((status == .authorizedAlways) || (status == .authorizedWhenInUse))
        {
            self.startLocation()
        }
        //self.startLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopMotion()
        self.stopLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //LOCATION
    
    var locationManager: CLLocationManager!
    func initializeLocation() { // called from start up method
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.startLocation()
        case .denied, .restricted:
            print("location not authorized")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        } }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
            self.startLocation()
        } else {
            self.stopLocation()
        }
    }
    func startLocation () {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    func stopLocation () {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        if let latitude = location?.coordinate.latitude {
            print("Latitude: \(latitude)")
            lattitudeLabel.text = ("Latitude: \(latitude)")
        }
        if let longitude = location?.coordinate.longitude {
            print("Longitude: \(longitude)")
            longitudeLabel.text = ("Longitude: \(longitude)")
        }
    }
}

