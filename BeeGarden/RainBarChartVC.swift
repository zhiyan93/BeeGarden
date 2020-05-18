//
//  RainBarChartVC.swift
//  BeeGarden
//
//  Created by steven liu on 3/5/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import UIKit
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import Charts

class RainBarChartVC: UIViewController,CLLocationManagerDelegate ,HalfModalPresentable {

    var lat = -37.813407
       var lon = 144.969730
       var activityIndicator: NVActivityIndicatorView!
       let locationManager = CLLocationManager()
    var rainLastDays = [Int:Double]()
    var rainForeDays = [Int:Double]()
    var rainDays = [Int:Double]()
    var watering = [-3:0,-2:10,-1:0,0:0,1:0,2:0,3:0]
    
    @IBOutlet var barChartView: CombinedChartView!
    
    @IBOutlet var wholeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barChartView.drawValueAboveBarEnabled = true
           barChartView.setScaleEnabled(false)
           barChartView.pinchZoomEnabled = false
               barChartView.leftAxis.enabled = true
               barChartView.rightAxis.enabled = true
            barChartView.xAxis.enabled =  true
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false
              barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelTextColor = UIColor.label
        barChartView.rightAxis.labelTextColor = UIColor.label
        barChartView.leftAxis.labelTextColor = UIColor.label
        barChartView.tintColor = UIColor.label
        barChartView.legend.textColor = UIColor.label
     
              barChartView.legend.enabled = true
        
        barChartView.backgroundColor = .systemGray6
               
               // Do any additional setup after loading the view.
               let indicatorSize: CGFloat = 150
               let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height/2 - indicatorSize)/2, width: indicatorSize, height: indicatorSize)
               activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.systemOrange, padding: 20.0)
        activityIndicator.backgroundColor = .clear
               view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
       // barChartView.backgroundColor  = .white
       barChartView.xAxis.valueFormatter = XAxisNameFormater()
       barChartView.xAxis.granularity = 1.0
        wholeView.layer.cornerRadius = 20
        //barChartView.animate(yAxisDuration: 1)
//        let ll = ChartLimitLine(limit: 30.0, label: "total water need")
//        barChartView.rightAxis.addLimitLine(ll)
         configureLocationServices()
        barChartView.setMyBorderColor()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let location = locations[0]
           lat = location.coordinate.latitude
           lon = location.coordinate.longitude
           self.locationManager.stopUpdatingLocation()
           
           for i in 1...3{
           let request = WeatherAPI.requestHistoryWeather(lat: lat, lon: lon, daybefore: i)
            request.responseJSON {
                data in
               
                
                 let jsonResponse = JSON(data.value!)
                 let dayRain =  WeatherAPI.calculateHisRainSum(jsonResponse: jsonResponse)
                 self.rainLastDays[-i] = dayRain
                
                self.rainDays.merge(self.rainLastDays) { (new, _) in new }
                self.setChart()
              
                
            }
         
           }
        let request = WeatherAPI.requestWeather(latitude: lat, longitude: lon)
        request.responseJSON {
            data in
             if self.activityIndicator.isAnimating == false {
                               self.activityIndicator.startAnimating()
                           }
            let jsonResponse = JSON(data.value!)
            let dayRain = WeatherAPI.calculateForeRainSum(jsonResponse: jsonResponse)
            print("forecast ",dayRain)
            self.rainForeDays = dayRain
            
            self.rainDays.merge(self.rainForeDays) { (new, _) in new }
            self.setChart()
              if self.activityIndicator.isAnimating == true {
                              self.activityIndicator.stopAnimating()
                          }
        }
             
 
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
    
    func setChart(){
            let items = rainDays
            var entries = [BarChartDataEntry]()
           var entrySums = [ChartDataEntry]()
          //  var values = [Double]()
            for (key,value) in items{
               let entry = BarChartDataEntry(x: Double(key), y: value)
                entries.append(entry)
                
                var s = 0.0
                for (k,v) in items {
                    if k <= key {
                        s = s + v
                    }
                }
                
                let entrySum = ChartDataEntry(x: Double(key), y: s)
                entrySums.append(entrySum)
                //values.append(value)
            }
            let set1 = BarChartDataSet(entries: entries,label: "rain fall")
        set1.setColor(UIColor.systemBlue)
        set1.valueTextColor = UIColor.label
           // let data = BarChartData(dataSet: set1)
           // barChartView.data = data
        
        entrySums.sort(by: { $0.x < $1.x })   //must sort before set dataset
        let lineSet = LineChartDataSet(entries: entrySums, label: "accumulated rain fall")
        lineSet.setColor(UIColor.systemOrange.withAlphaComponent(0.6))
        lineSet.drawCirclesEnabled = false
        lineSet.drawValuesEnabled = false
        lineSet.lineWidth = 3
        let data: CombinedChartData = CombinedChartData()
        data.barData = BarChartData(dataSets: [set1])
        data.lineData = LineChartData( dataSets: [lineSet])

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

final class XAxisNameFormater: NSObject, IAxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

        let pnday = NSCalendar.current.date(byAdding: .day, value: Int(value), to: Date())
        let formatter = DateFormatter()
              formatter.dateFormat = "dd/MMM"

        return formatter.string(from: pnday ?? Date())
    }

}
