//
//  Constants.swift
//  ApiTeste
//
//  Created by Bruno Vieira on 25/09/17.
//  Copyright © 2017 Bruno Vieira. All rights reserved.
//

import Foundation

let BASE_URL = "http://samples.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "b1b15e88fa797225412429c1c50c122a1"

typealias DownloadComplete = () -> ()
//http://samples.openweathermap.org/data/2.5/forecast/daily?lat=-36&lon=123&cnt=10&appid=b1b15e88fa797225412429c1c50c122a1
//let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)-36\(LONGITUDE)123\(APP_ID)\(API_KEY)"
let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=42a1771a0b787bf12e734ada0cfc80cb"
let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=42a1771a0b787bf12e734ada0cfc80cb"

