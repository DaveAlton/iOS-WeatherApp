//
//  ViewController.swift
//  WeatherApp
//
//  Created by Dave Alton on 2015-08-21.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//
//  Weather icons from https://github.com/TylerEich/Alfred-Extras/tree/master/Experimental/darksky/icons

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var degreesLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var dewpointLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var dailyContainer: DailyContainer!
    var hourlyContainer: HourlyContainer!

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
                    
                    CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
                        if error != nil {
                            println("Reverse geocoder failed with error" + error.localizedDescription)
                            return
                        }
                        
                        if placemarks.count > 0 {
                            let pm = placemarks[0] as! CLPlacemark
                            self.locationLabel.text = "\(pm.locality), \(pm.administrativeArea)"
                            println(pm.locality)
                            println(pm.administrativeArea)
                        } else {
                            println("Problem with the data received from geocoder")
                        }
                    })
                    
                    var currentTemp = json["currently"]["temperature"].asDouble!
                    self.degreesLabel.text = "\(Int(round(currentTemp)))°"
                    
                    var weatherString = json["currently"]["icon"].asString!
                    self.weatherIcon.image = UIImage(named: weatherString)
                    
                    var summary = json["currently"]["summary"].asString!
                    self.summaryLabel.text = summary
                    
                    var humidity = json["currently"]["humidity"].asDouble! * 100
                    self.humidityLabel.text = "Humidity: \(Int(round(humidity)))%"
                    
                    var dewpoint = json["currently"]["dewPoint"].asDouble!
                    self.dewpointLabel.text = "Dewpoint: \(Int(round(dewpoint)))°"
                    
                    var wind = json["currently"]["windSpeed"].asDouble!
                    self.windLabel.text = "Wind: \(Int(round(wind)))mph"
                    
                    var dailyForecast = Array<Day>()
                    for var i = 0; i < json["daily"]["data"].asArray!.count; i++ {
                        var dateInt = json["daily"]["data"][i]["time"].asInt!
                        var high = json["daily"]["data"][i]["temperatureMax"].asDouble!
                        var low = json["daily"]["data"][i]["temperatureMin"].asDouble!
                        var iconString = json["daily"]["data"][i]["icon"].asString!
                        var day = Day(dateInt: dateInt, high: high, low: low, iconString: iconString)
                        dailyForecast.append(day)
                    }
                    dailyForecast.removeAtIndex(0)
                    self.dailyContainer.updateForecast(dailyForecast)
                    
                    var hourlyForecast = Array<Hour>()
                    for var i = 0; i < json["hourly"]["data"].asArray!.count; i++ {
                        var dateInt = json["hourly"]["data"][i]["time"].asInt!
                        var temp = json["hourly"]["data"][i]["temperature"].asDouble!
                        var iconString = json["hourly"]["data"][i]["icon"].asString!
                        var hour = Hour(dateInt: dateInt, temp: temp, iconString: iconString)
                        hourlyForecast.append(hour)
                    }
                    self.hourlyContainer.updateForecast(hourlyForecast)
                    
                });
            });
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "daily" {
            self.dailyContainer = segue.destinationViewController as! DailyContainer
        } else if segue.identifier == "hourly" {
            self.hourlyContainer = segue.destinationViewController as! HourlyContainer
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

