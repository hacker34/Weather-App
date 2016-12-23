//
//  WeatherCell.swift
//  rainyshinycloudy
//
//  Created by Johnny Hacking on 12/19/16.
//  Copyright © 2016 HackingInnovations. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    
    //function to setup data from forecaset class
    func configureCell(forecast: Forecast){
        lowTemp.text = "\(forecast.lowTemp)"
        highTemp.text = "\(forecast.highTemp)"
        weatherType.text = forecast.weatherType
        dayLabel.text = forecast.date
        weatherIcon.image = UIImage(named: forecast.weatherType)
        
    }

}
