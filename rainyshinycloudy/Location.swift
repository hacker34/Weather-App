//
//  Location.swift
//  rainyshinycloudy
//
//  Created by Johnny Hacking on 12/20/16.
//  Copyright © 2016 HackingInnovations. All rights reserved.
//

import Foundation
import CoreLocation

class Location{
    // static var is a global variable and then must be initilized
    static var sharedInstance = Location()
    private init(){}
    
    var latitude: Double!
    var Longitude: Double!
}
