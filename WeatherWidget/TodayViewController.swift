//
//  TodayViewController.swift
//  WeatherWidget
//
//  Created by Dave Alton on 2015-08-22.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    @IBOutlet var degreesLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    self.degreesLabel.text = "\(Int(round(currentTemp)))°"
                    
                    var weatherString = json["currently"]["icon"].asString!
                    self.weatherIcon.image = UIImage(named: weatherString)
                    
                    var summary = json["currently"]["summary"].asString!
                    self.summaryLabel.text = summary
                    
                });
            });
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var margins = UIEdgeInsets(top: defaultMarginInsets.top, left: defaultMarginInsets.left, bottom: 10, right: defaultMarginInsets.right)
        return margins
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
}
