//
//  Forecast.swift
//  rainyshinycloudy
//
//  Created by Johnny Hacking on 12/18/16.
//  Copyright © 2016 HackingInnovations. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date: String {
        if _date == nil{
            _date = ""
        }
        return _date
    }
    
    var weatherType: String{
        if _weatherType == nil{
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String{
        if _highTemp == nil{
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String{
        if _lowTemp == nil{
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    //initilizing all the data
    
    init(weatherDict: Dictionary<String, AnyObject>){
        // parsing through the data/Dictionaires like in the other class that is passed into weatherDict
        
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject>{
            if let min = temp["min"] as? Double{
                let kelvinToFarenheitPreDivision = (min * (9/5) - 459.67)
                
                let kevlvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._lowTemp = "\(kevlvinToFarenheit)"
                // print(self._currentTemp)
            }
            if let max = temp["max"] as? Double{
                // temp is coming in at kelvin so need to convert
                let kelvinToFarenheitPreDivision = (max * (9/5) - 459.67)
                
                let kevlvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._highTemp = "\(kevlvinToFarenheit)"
                // print(self._currentTemp)
                
            }
        // end of the temp dictionary that we need so pop out a level
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>]{
            //weather Dictionary is an array of Dictionaires
            // I am pulling out the first dictionary in the array so that is why its set to [0]
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
            
        }
        
        if let date = weatherDict["dt"] as? Double{
            // JSON is giving us a unix timestamp
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            //using dot notation to reference our extension that converts it to a string
            self._date = unixConvertedDate.dayOfTheWeek()
        }
        
    }
    
}
//writing an extension to get the day of the week so it displays correctly
extension Date{
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        // This formater removes everything except the day of the week
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
