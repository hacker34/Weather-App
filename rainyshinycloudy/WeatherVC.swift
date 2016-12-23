//
//  WeatherVC.swift
//  rainyshinycloudy
//
//  Created by Johnny Hacking on 12/16/16.
//  Copyright © 2016 HackingInnovations. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    //for a Table view you need a table view delagate which tells the table view how to handle the data and a data source connects the data to the table view
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //create varable to starting using the location manager.  Also import the CoreLocation class and the cllocationmanagerDelegat
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    //initiliaze the classes in variables
    var currentWeather = CurrentWeather()
    var forecast: Forecast!
    // arrary variable set to our Forecast class to store multi dictionaries of JSON data
    var forecasts = [Forecast]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup location manager delagate and task
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        //if you dont do this the tablview wont know where to look for it
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // putting it here in viewDidAppear so that it will run before it downloads Forecast Data
        locationAuthStatus()
    }
    
    //setup a function to call for location.  If we have authorized it then it will run the code and if not then it will ask and run
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            //if authorized then we save that location to the variable.  Remember to setup plist to ask for authorization
           currentLocation = locationManager.location
            //calling Location class and assigning to variables which are global
           Location.sharedInstance.latitude = currentLocation.coordinate.latitude
           Location.sharedInstance.Longitude = currentLocation.coordinate.longitude
           //print(Location.sharedInstance.latitude)
           //print("Longitute \(Location.sharedInstance.Longitude)")
            
            // had to move this code from viewDidLoad cuz it kept crashing trying to get data when it didn't have locaiton yet.
            //load function to download the JSON data
            currentWeather.downloadWeatherDetails {
                //Code to update UI
                self.downloadForecastData {
                    self.updateMainUI()
                }
                
            }
        }else{
            locationManager.requestWhenInUseAuthorization()
            //now since it ran the else statement I need to recall the function so that it can get the location
            locationAuthStatus()
        }
        //Using a singlition class (Location.swift) to save the location 
        
    }
    
    //download forecast weather data
    func downloadForecastData(completed: @escaping DownloadComplete)  {
        //Downloading forecast weather data for TableView
        let forecastURL = URL(string: FORECAST_URL)!
        
        // storing everything we get from JSON and storing it in a the result var and then putting it into a dictionary
        Alamofire.request(forecastURL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject>{
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>]{
                    // now that we have our list we want to run a for loop to parse throught the information for everyday
                    // Their is an array of Dictionaries under the 'list' Dictionary in the JSON,  its parsing through those and storing each peice to the forecast array
                    for obj in list{
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        //print(obj)
                    }
                    // removes todays to start with tomorrows
                    self.forecasts.remove(at: 0)
                    // reloads the data after its populated
                    self.tableView.reloadData()
                    
                }
            }
            completed()
        }
    }
    
    //For table view you need 3 functions always and they follow
    
    //table the table view to return how many sections we only designed 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    //How many cells do we want on the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // the cell var below is what is telling the function to recreate for  the cell
        // I added the if later on and the cast as? weatherCell once I had that class built just FYI
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell{
            
            // gets the info that was appended to the array
            // then configures the cell with the function we wrote in WeatherCell class
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
            
        }else{
            // This is so the app doesn't crash
            return WeatherCell()
        }
        
        
        
        
        // this function is looking for an identifier that we set our tableview cell to, in this case we named it weatherCell
        // Inserted above  later on after weatherCell class creating return cell
        // this above function also makes it so the iphone only creates the tableview cells that are shown on the phone so if its only 4 then it only creats 4 and this will save memory.  this way its not slowing things down trying to create in this case 6 cells.
    }
    
    func updateMainUI(){
        //FYI currentWeather is var set up above to the CurrentWeather class
        dateLbl.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)°"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        // pulling image from assest folder
        // the UIImage is looking for the name of the image which is cleaverly named the same as the weather type so that is why we passed that value in as the string so that its pulling it dynamicly
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
}

