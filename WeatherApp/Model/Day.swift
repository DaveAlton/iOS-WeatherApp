//
//  Day.swift
//  WeatherApp
//
//  Created by Dave Alton on 2015-08-21.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import Foundation
import UIKit

class Day {
    
    var dayOfWeek: String {
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(dateInt))
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: date)
        let weekDay = myComponents.weekday
        let week = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        return week[weekDay - 1]
    }
    private var dateInt: Int
    var high: Int
    var low: Int
    private var iconString: String
    var icon: UIImage {
        return UIImage(named: iconString)!
    }
    
    init(dateInt: Int, high: Double, low: Double, iconString: String){
        self.dateInt = dateInt
        self.high = Int(round(high))
        self.low = Int(round(low))
        self.iconString = iconString
    }
    
}