//
//  PlantVC.swift
//  BeeGarden
//
//  Created by steven liu on 15/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import Charts

class PlantVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    let apiKey = "6fe69d2a83424b6a2d2883d24664bc5d"
       var lat = 11.344533
       var lon = 104.33322
       var activityIndicator: NVActivityIndicatorView!
       let locationManager = CLLocationManager()
    var rainLastDays = [Int:Double]()
    var rainForeDays = [Int:Double]()
    var rainDays = [Int:Double]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
     //barChartView.delegate = self
     
     //barChartView.drawBarShadowEnabled = false
     barChartView.drawValueAboveBarEnabled = true
    barChartView.setScaleEnabled(false)
    barChartView.pinchZoomEnabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
       barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
       barChartView.legend.enabled = false
        
        // Do any additional setup after loading the view.
        let indicatorSize: CGFloat = 100
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor(displayP3Red: 244/255, green: 189/255, blue: 32/255, alpha: 0.8)
        view.addSubview(activityIndicator)
       
       
       // locationManager.requestWhenInUseAuthorization()
        
        
//        if(CLLocationManager.locationServicesEnabled()){
//
//                  locationManager.delegate = self
//                  locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                  locationManager.startUpdatingLocation()
//
//              }
        configureLocationServices()
           
     
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        self.locationManager.stopUpdatingLocation()
        
        for i in 1...5{
            getRainThatDay(daybefore: i)
        }
          getRainForecast()
      
     
    
        
        
    }
    
    private func configureLocationServices() {
              locationManager.delegate = self
              let status = CLLocationManager.authorizationStatus()
              if  status == .notDetermined {
                  locationManager.requestAlwaysAuthorization()
              } else if status == .authorizedAlways || status == .authorizedWhenInUse {
                  beginLocationUpdates(locationManager: locationManager)
              }
          }
    
    private func beginLocationUpdates(locationManager : CLLocationManager) {
         //  mapView.showsUserLocation = true
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.startUpdatingLocation()
       
       }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
    
    func lastNDay(n: Int) -> [Int]{
        let today = Date()
       var dayArr = [Int]()
    var i = 0
        while(i<n){
            let pnday = NSCalendar.current.date(byAdding: .day, value: -i, to: today)
            let pndayInterval = Int(pnday!.timeIntervalSince1970)
            dayArr.append(pndayInterval)
            i = i+1
        }
       // let today : TimeInterval = Date().timeIntervalSince1970
        return dayArr
    }
    
    func getRainThatDay(daybefore:Int) {
        
        if(self.activityIndicator.isAnimating == false) {
            self.activityIndicator.startAnimating()
        }
        let pnday = NSCalendar.current.date(byAdding: .day, value: -daybefore, to: Date())
        let pndayInterval = Int(pnday!.timeIntervalSince1970)
        var rainSum:Double = 0.0
            let request = AF.request("http://api.openweathermap.org/data/2.5/onecall/timemachine?lat=\(lat)&lon=\(lon)&dt=\(pndayInterval)&appid=\(apiKey)")
                request.responseJSON {
                    (data) in
                   // print(data)
                    
                    let jsonResponse = JSON(data.value!)
                   // print(jsonResponse)
                  let jsonArr = jsonResponse["hourly"].array!
                    
                    for h in jsonArr {
                        let hourRain = h["rain"]["1h"].doubleValue
                        //print(hourRain)
                        rainSum = rainSum + hourRain
                    }
                   
                    print(self.rainLastDays)
                    self.rainLastDays[-daybefore] = rainSum
                    
                    if(self.activityIndicator.isAnimating == true){
                         self.activityIndicator.stopAnimating()
                    }
                    
                    self.rainDays.merge(self.rainLastDays) { (new, _) in new }
                    self.setChart()
               
                   
                }
    }
    
    func getRainForecast()
    {
        if(self.activityIndicator.isAnimating == false) {
                   self.activityIndicator.startAnimating()
               }
      
        let request = AF.request("http://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=\(apiKey)")
                      request.responseJSON {
                          (data) in
                        //  print(data)
                          
                          let jsonResponse = JSON(data.value!)
                         // print(jsonResponse)
                        let jsonArr = jsonResponse["daily"].array!
                          
                        for d in 0...7 {
                            let dayRain = jsonArr[d]["rain"].doubleValue
                              //print(hourRain)
                            self.rainForeDays[d] = dayRain
                            
                          }
                        print(self.rainForeDays)
                        self.rainDays.merge(self.rainForeDays) { (new, _) in new }
                            
                          
                          
                          if(self.activityIndicator.isAnimating == true){
                               self.activityIndicator.stopAnimating()
                          }
                     
                        self.setChart()
                        self.barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                      }
    }
    
    func setChart(){
        let items = rainDays
        var entries = [BarChartDataEntry]()
      //  var values = [Double]()
        for (key,value) in items{
           let entry = BarChartDataEntry(x: Double(key), y: value)
            entries.append(entry)
            //values.append(value)
        }
        let set1 = BarChartDataSet(entries: entries,label: "rain fall")
        set1.setColor(UIColor(displayP3Red: 244/255, green: 189/255, blue: 32/255, alpha: 1.0))
        let data = BarChartData(dataSet: set1)
        barChartView.data = data
    
//        let meanValue = values.reduce(0,+)/Double(values.count)
//        let ll = ChartLimitLine(limit: meanValue, label: "mean rainfall")
//        barChartView.rightAxis.addLimitLine(ll)
       
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


         
//
//          if currentCoordinate == nil {
//        zoomToLatestLocation(with: latestLocation.coordinate)
//          //    addAnnotations()
//          }
         

      
      
    
    
