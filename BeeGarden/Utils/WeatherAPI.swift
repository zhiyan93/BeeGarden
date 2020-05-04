//
//  WeatherAPI.swift
//  BeeGarden
//
//  Created by steven liu on 30/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct WeatherAPI {
    
   static let apiKey = "6fe69d2a83424b6a2d2883d24664bc5d"
    
    static func requestWeather(latitude: Double,longitude: Double ) -> DataRequest {
   
        let request = AF.request("http://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)")
        return request
    }
    
    static func fetchDataFromRequest(jsonResponse:JSON) -> String {
        let currentObj = jsonResponse["current"]
      // print(currentObj)
        let temp = currentObj["temp"].doubleValue - 273
        let tempRound = temp.round(to: 1)
            let pressure = currentObj["pressure"].doubleValue
        let humidity = currentObj["humidity"].doubleValue
     //    let dewPoint = currentObj["dew_point"].doubleValue
            let clouds = currentObj["clouds"].doubleValue
            let windSpeed = currentObj["wind_speed"].doubleValue
            let windDeg = currentObj["wind_deg"].doubleValue
            let wDesc = currentObj["weather"].array![0]
                let weatherDesc = wDesc["main"].stringValue
        //  let icon = wDesc["icon"].stringValue

      
      return " weather: \(weatherDesc);\n tempetature: \(tempRound);\n pressure: \(pressure); \n humidity: \(humidity)%;\n clouds: \(clouds)%;\n wind speed: \(windSpeed);\n wind direction: \(windDeg)"
                                  
    }
    
    static func requestHistoryWeather(lat:Double,lon: Double,daybefore: Int) -> DataRequest{
        let pnday = NSCalendar.current.date(byAdding: .day, value: -daybefore, to: Date())
            let pndayInterval = Int(pnday!.timeIntervalSince1970)
           // var rainSum:Double = 0.0
                let request = AF.request("http://api.openweathermap.org/data/2.5/onecall/timemachine?lat=\(lat)&lon=\(lon)&dt=\(pndayInterval)&appid=\(apiKey)")
        return request
    }
    
    static func calculateHisRainSum(jsonResponse: JSON) -> Double {
        var rainSum = 0.0
        let jsonArr = jsonResponse["hourly"].array!
          
          for h in jsonArr {
              let hourRain = h["rain"]["1h"].doubleValue
              //print(hourRain)
              rainSum = rainSum + hourRain
          }
        return rainSum.round(to: 1)
    }
    
    
    static func calculateForeRainSum(jsonResponse: JSON) -> [Int:Double] {
        var rainForecast = [0:0.0,1:0.0,2:0.0,3:0.0]
        let jsonArr = jsonResponse["daily"].array!
          
        for d in 0...3 {
            let dayRain = jsonArr[d]["rain"].doubleValue
              //print(hourRain)
            rainForecast[d] = dayRain.round(to: 1)
            
          }
        return rainForecast
    }
    

}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
