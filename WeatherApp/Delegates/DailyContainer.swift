//
//  DailyDelegate.swift
//  WeatherApp
//
//  Created by Dave Alton on 2015-08-21.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import Foundation
import UIKit

class DailyContainer: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var forecast: Array<Day>!
    
    func updateForecast(forecast: Array<Day>){
        self.forecast = forecast
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        var day = forecast[indexPath.item]
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        var dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: 20))
        dayLabel.text = day.dayOfWeek
        dayLabel.textAlignment = .Center
        cell.addSubview(dayLabel)
        
        var iconImage = UIImageView(frame: CGRect(x: 0, y: dayLabel.frame.size.height, width: cell.frame.size.width, height: 40))
        iconImage.image = day.icon
        iconImage.contentMode = .ScaleAspectFit
        cell.addSubview(iconImage)
        
        var highLabel = UILabel(frame: CGRect(x: 0, y: iconImage.frame.size.height + iconImage.frame.origin.y, width: cell.frame.size.width, height: 20))
        highLabel.text = "H:\(day.high)°"
        highLabel.textAlignment = .Center
        cell.addSubview(highLabel)
        
        var lowLabel = UILabel(frame: CGRect(x: 0, y: highLabel.frame.size.height + highLabel.frame.origin.y, width: cell.frame.size.width, height: 20))
        lowLabel.text = "L:\(day.low)°"
        lowLabel.textAlignment = .Center
        cell.addSubview(lowLabel)
        
        return cell
    }
    
}