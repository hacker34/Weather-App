//
//  CurrentWeather.swift
//  rainyshinycloudy
//
//  Created by Johnny Hacking on 12/17/16.
//  Copyright © 2016 HackingInnovations. All rights reserved.
//
//  This call will store all the variables that will keep track of weather data

import UIKit
import Alamofire

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    //we are implementing data hiding that allows only certain funciton access these information which is a good practice.
    
    //These function will ensure that our app will not crash
    
    var cityName: String{
        if _cityName == nil{
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String{
        if _date == nil{
            _date = ""
        }
        //Formats our Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    var weatherType: String{
        if _weatherType == nil{
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double{
        if _currentTemp == nil{
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    //functions to actually download the weather data needed for API
    //Need to create the DownloadComplete in constants file cuz it doesn't exsist
    //Be sure to set the app to allow basic url to work and not just https.
    func downloadWeatherDetails(completed: @escaping DownloadComplete){
        //Alamofire download
        //let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)
        //start Alamofire, we are passing the request in a resonse to see what we get.
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            
            
            
            //Function to start parsing the JSON data
            if let dict = result.value as? Dictionary<String, AnyObject>{
                // dictionary is the dictionaries of the JSON Keys inside the object
                // I assinged a var to the 'name' Dictionary  inside the JSON and cast it as a string
                // then assigned our city name equal to it.  Boom
                if let name = dict["name"] as? String{
                    self._cityName = name.capitalized
                    //print(self._cityName)
                }
                // weather is an array in the JSON that I need to dive into it deeper
                // in the JSON weather is an array of Dictionaires so we went deeper and the first dictionary in the weather array we pulled out main and set its value to weatherType.
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>]{
                    if let main = weather[0]["main"] as? String{
                        self._weatherType = main.capitalized
                       // print(self._weatherType)
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject>{
                    
                    if let currentTemperature = main["temp"] as? Double {
                        // temp is coming in at kelvin so need to convert
                        let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                        
                        let kevlvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                        
                        self._currentTemp = kevlvinToFarenheit
                       // print(self._currentTemp)
                    }
                }
            }
            // lets the function know that the downloaded data is complete
            completed()
        }
        
    }
    
    
}
