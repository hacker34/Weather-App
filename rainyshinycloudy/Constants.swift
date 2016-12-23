//
//  Constants.swift
//  rainyshinycloudy
//
//  Created by Johnny Hacking on 12/17/16.
//  Copyright © 2016 HackingInnovations. All rights reserved.
//
//  This is a file that will have infomation that will stay the same but allow us to use it anywhere in the app

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATTITUE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "3eeead2e516325791479bc322be57edf"

//this tells our func that the download is complete
typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATTITUE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.Longitude!)\(APP_ID)\(API_KEY)"
let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.Longitude!)&cnt=10&mode=json&appid=3eeead2e516325791479bc322be57edf"
