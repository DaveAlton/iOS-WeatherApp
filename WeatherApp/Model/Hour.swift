//
//  Hour.swift
//  WeatherApp
//
//  Created by Dave Alton on 2015-08-22.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import Foundation
import UIKit

class Hour {
    
    var time: String {
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(dateInt))
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitHour, fromDate: date)
        var ampm = myComponents.hour < 12 ? "am" : "pm"
        var hour = myComponents.hour % 12
        hour = hour == 0 ? 12 : hour
        return "\(hour)\(ampm)"
    }
    private var dateInt: Int
    var temp: Int
    private var iconString: String
    var icon: UIImage {
        return UIImage(named: iconString)!
    }
    
    init(dateInt: Int, temp: Double, iconString: String){
        self.dateInt = dateInt
        self.temp = Int(round(temp))
        self.iconString = iconString
    }
    
}
