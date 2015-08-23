//
//  HourlyContainer.swift
//  WeatherApp
//
//  Created by Dave Alton on 2015-08-22.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import Foundation
import UIKit

class HourlyContainer: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var forecast: Array<Hour>!
    
    func updateForecast(forecast: Array<Hour>){
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
        var hour = forecast[indexPath.item]
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        var dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: 20))
        dayLabel.text = hour.time
        dayLabel.textAlignment = .Center
        cell.addSubview(dayLabel)
        
        var iconImage = UIImageView(frame: CGRect(x: 0, y: dayLabel.frame.size.height, width: cell.frame.size.width, height: 40))
        iconImage.image = hour.icon
        iconImage.contentMode = .ScaleAspectFit
        cell.addSubview(iconImage)

        var tempLabel = UILabel(frame: CGRect(x: 0, y: iconImage.frame.size.height + iconImage.frame.origin.y, width: cell.frame.size.width, height: 20))
        tempLabel.text = "\(hour.temp)°"
        tempLabel.textAlignment = .Center
        cell.addSubview(tempLabel)
        
        return cell
    }
    
}