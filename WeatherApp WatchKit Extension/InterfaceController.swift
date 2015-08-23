//
//  InterfaceController.swift
//  WeatherApp WatchKit Extension
//
//  Created by Dave Alton on 2015-08-22.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    
    @IBOutlet var tempLabel: WKInterfaceLabel!
    @IBOutlet var summaryLabel: WKInterfaceLabel!
    
    var locationManager: CLLocationManager!
    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        locationManager = CLLocationManager()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        let Device = UIDevice.currentDevice()
        let iosVersion = NSString(string: Device.systemVersion).doubleValue
        var iOS8 = iosVersion >= 8
        if iOS8 {
            locationManager!.requestWhenInUseAuthorization()
        }
        locationManager!.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        var oldLat = oldLocation == nil ? 0 : oldLocation.coordinate.latitude
        var oldLng = oldLocation == nil ? 0 : oldLocation.coordinate.longitude
        
        if abs(abs(oldLat) - abs(newLocation.coordinate.latitude)) > 1 || abs(abs(oldLng) - abs(newLocation.coordinate.longitude)) > 1 {
            var lat = newLocation.coordinate.latitude
            var lng = newLocation.coordinate.longitude
            
            var url = "https://api.forecast.io/forecast/203bf0976335ed98863b556ed9f61f79/\(lat),\(lng)"
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                var json = JSON(url: url)
                dispatch_async( dispatch_get_main_queue(), {
                    
                    var currentTemp = json["currently"]["temperature"].asDouble!
                    self.tempLabel.setText("\(Int(round(currentTemp)))°")
                    
                    var summary = json["currently"]["summary"].asString!
                    self.summaryLabel.setText(summary)
                    
                });
            });
        }
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
