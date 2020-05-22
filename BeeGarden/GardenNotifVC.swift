//
//  GardenNotifVC.swift
//  BeeGarden
//
//  Created by steven liu on 3/5/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import SwiftEntryKit
import CoreLocation
import NVActivityIndicatorView
import SwiftyJSON
import UICircularProgressRing

class GardenNotifVC: UIViewController,CLLocationManagerDelegate, DatabaseListener {
    var listenerType = ListenerType.plantRecord
    var records  = [PlantRecordEntity]()
    weak var databaseController : DatabaseProtocol?
    
    func onObserveListChange(change: DatabaseChange, observesDB: [ObserveEntity]) {
        
    }
    
    func onBeeListChange(change: DatabaseChange, beesDB: [BeeEntity]) {
        
    }
    
    func onKnowledgeListChange(change: DatabaseChange, knowsDB: [KnowledgeEntity]) {
        
    }
    
    func onSpotListChange(change: DatabaseChange, spotsDB: [SpotEntity]) {
        
    }
    
    func onFlowerListChange(change: DatabaseChange, flowersDB: [FlowerEntity]) {
        
    }
    
    func onRecordListChange(change: DatabaseChange, recordsDB: [PlantRecordEntity]) {
        records = recordsDB
    }
    
    func onGardenChange(change: DatabaseChange, gardenPlants: [FlowerEntity]) {
        
    }
    

    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    var waterAmountInput = 30
    
    var lat = -37.813407
       var lon = 144.969730
       var activityIndicator: NVActivityIndicatorView!
       let locationManager = CLLocationManager()
    var rainLastDays = [Int:Double]()
    var rainForeDays = [Int:Double]()
    var rainDays = [Int:Double]()
    var watering = [-3:0,-2:10,-1:0,0:0,1:0,2:0,3:0]
    var progressDict = ["amount":30,"rain":0,"record":0]
   // var timePickerValue = Date()
    @IBOutlet weak var waterAmount: UILabel!
    
    @IBOutlet weak var setWaterAmount: UIButton!
    
    @IBOutlet weak var rainSumLabel: UILabel!
    
    @IBOutlet weak var rainDetailBtn: UIButton!
    
    
    @IBOutlet weak var recordLabel: UILabel!
    
    
   
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    @IBOutlet var wholeView: UIView!
    
    
    @IBOutlet weak var notifSwitch: UISwitch!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
  //  @IBOutlet weak var setTimeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setWaterAmount.layer.cornerRadius = 10
        self.rainDetailBtn.layer.cornerRadius = 10
        self.wholeView.layer.cornerRadius = 15
        let indicatorSize: CGFloat = 100
                     let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
                     activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
              activityIndicator.backgroundColor = .clear
                     view.addSubview(activityIndicator)
        
          configureLocationServices()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            databaseController = appDelegate.databaseController   //coredata
        
         NotificationCenter.default.addObserver(self, selector: #selector(recordChange(notification:)), name: NSNotification.Name(rawValue: "recordChange"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(progressChange(notification:)), name: NSNotification.Name(rawValue: "progressChange"), object: nil)
        
        self.progressRing.style = .inside
        progressRing.innerRingColor = UIColor(named:"ButtonColor1")!
        progressRing.outerRingColor = UIColor.systemOrange.withAlphaComponent(0.8)
        progressRing.fontColor = UIColor.label
        
        self.timePicker.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
        self.timePicker.timeZone = TimeZone(abbreviation: "AET")
     //   setTimeBtn.layer.cornerRadius = 10
        //self.timePicker.tintColor = .white
        view.setMyBorderColor()
       // view.layer.cornerRadius = 10
    }
    
    @objc func recordChange(notification: NSNotification) {
             //  self.collectionView.reloadData()
          let indexInfo = notification.userInfo
        //   print("indexInfo",indexInfo)
          print("value", indexInfo![1])
        var waterCount = 0.0
           waterCount = indexInfo![1] as! Double
        self.recordLabel.text =  "Records:\(waterCount)"
        
        
        progressDict["record"] = Int(waterCount)
                  NotificationCenter.default.post(name: NSNotification.Name("progressChange"), object: nil,userInfo: progressDict)

             }
    
    @objc func progressChange(notification: NSNotification) {
               //  self.collectionView.reloadData()
            let indexInfo = notification.userInfo
          //   print("indexInfo",indexInfo)
            print("amount\(indexInfo!["amount"]) record\(indexInfo!["record"]) rain\(indexInfo!["rain"])")
        let amount = indexInfo!["amount"] as! Int
        let record = indexInfo!["record"] as! Int
        let rain = indexInfo!["rain"] as! Int
         let value = Float(record + rain) / Float(amount) * 100
        
        self.progressRing.startProgress(to: CGFloat(value), duration: 1)
            
         // self.recordLabel.text =  "Total Watering Records: \(waterCount)"

               }
    

    
    @IBAction func setAmountAct(_ sender: Any) {
        TopNotesPush.bottomFormPush(title: "Set water amount in 7 days", placeHoders: ["(most plants needs 30 Litres per square)"], buttonTitle: " SET ", action: amountShouldReturn )
        
        
        
    }
    
    
    @IBAction func rainDetailAct(_ sender: Any) {
        let chartView  =  storyboard?.instantiateViewController(withIdentifier: "rainBarChartView") as! RainBarChartVC
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: chartView)
        chartView.modalPresentationStyle = .custom
        chartView.transitioningDelegate = self.halfModalTransitioningDelegate
        present(chartView, animated: true)
        
    }
    
    
    @IBAction func notifSwitchAct(_ sender: Any) {
        
      
        
        if self.notifSwitch.isOn{
            setNotiTime()
            UserDefaults.standard.set(true,forKey: "waterNotifSwitch")
            let notifTime = UserDefaults.standard.object(forKey: "notifTime") as? Date
            addDailyNotif(time: notifTime ?? Date(), uid: "WateringNotification", title: "Bee Mate", body: "Remember to water your garden today")
          
        }
            
        else {
            UserDefaults.standard.set(false,forKey: "waterNotifSwitch")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:["WateringNotification"])
        }
        
    }
    
//    @IBAction func setNotifAct(_ sender: Any) {
//        let setTime = self.timePicker.date
//
//
//         UserDefaults.standard.set(setTime,forKey: "notifTime")
//        print("timeset\(setTime)")
//        let nowComponents = Calendar.current.dateComponents([.hour,.minute], from: setTime )
//        TopNotesPush.push(message: "notification will be sent at \(nowComponents.hour ?? 0) : \(nowComponents.minute ?? 0) each day", color: .color(color: Color.LightBlue.a700) )
//
//
//
//        if self.notifSwitch.isOn {
//            addDailyNotif(time: setTime, uid: "WateringNotification", title: "Bee Mate", body: " Remember to water your garden today")
//        }
//
//    }
    
    func setNotiTime() {
        let setTime = self.timePicker.date
            
            
             UserDefaults.standard.set(setTime,forKey: "notifTime")
            print("timeset\(setTime)")
            let nowComponents = Calendar.current.dateComponents([.hour,.minute], from: setTime )
            TopNotesPush.push(message: "notification will be sent at \(nowComponents.hour ?? 0) : \(nowComponents.minute ?? 0) each day", color: .color(color: Color.LightBlue.a700) )

                addDailyNotif(time: setTime, uid: "WateringNotification", title: "Bee Mate", body: " Remember to water your garden today")
            
        
    }
    
    
    private func addDailyNotif(time: Date, uid: String, title: String, body: String){
        
        let nowComponents = Calendar.current.dateComponents([.hour,.minute], from: time )
        
        let center = UNUserNotificationCenter.current()
                         center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
                             
                         }
        
        let content = UNMutableNotificationContent()
                        content.title = title
                        content.body = body
                        content.badge = NSNumber(value: 1)
                        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: nowComponents, repeats: true)
                        
                        let uuidString = uid
                        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                                        center.add(request) { (error : Error?) in
                                            if let theError = error {
                                                print(theError as! String)
                                            }
                                        }
        
        
    }
    
   
    
    func amountShouldReturn(input: String) {
        if let num : Int = Int(input), num < 1000  {
            print(num)
            SwiftEntryKit.dismiss()
           UserDefaults.standard.set(num, forKey: "waterAmount")
            waterAmountInput = num
            self.waterAmount.text = "Water amount 7days: \(num)"
            
            progressDict["amount"] = waterAmountInput
            NotificationCenter.default.post(name: NSNotification.Name("progressChange"), object: nil,userInfo: progressDict)
        }
       
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
          let waterAmount = UserDefaults.standard.object(forKey: "waterAmount") as? Int // Here you look if the Bool value exists, if not it means that is the first time the app is opened
           var res = 30
               //
               if waterAmount == nil {
                   
                   UserDefaults.standard.set(30, forKey: "waterAmount")
                   res = 30
               }
               else {
                res = waterAmount ?? 30
    }
        self.waterAmount.text = "Water amount 7 days: \(res)"
        waterAmountInput = res
       // databaseController?.addListener(listener: self)
        
       // recordLabel.text = "Total Watering Records:"
    progressDict["amount"] = waterAmountInput
    NotificationCenter.default.post(name: NSNotification.Name("progressChange"), object: nil,userInfo: progressDict)
        
        
        let waterNotifSwitch = UserDefaults.standard.object(forKey: "waterNotifSwitch") as? Bool
        
        if waterNotifSwitch == nil {
            UserDefaults.standard.set(false,forKey: "waterNotifSwitch")
            self.notifSwitch.setOn(false, animated: true)
        }
        else if waterNotifSwitch == false {
             self.notifSwitch.setOn(false, animated: true)
        }
        else if waterNotifSwitch == true {
            self.notifSwitch.setOn(true, animated: true)
        }
        
        
         let notifTime = UserDefaults.standard.object(forKey: "notifTime") as? Date
        if notifTime == nil {
            UserDefaults.standard.set(Date(),forKey: "notifTime")
            self.timePicker.date = Date()
        }
        else {
            self.timePicker.date = notifTime ?? Date()
        }
        
}
    
    override func viewWillDisappear(_ animated: Bool) {
      //  databaseController?.removeListener(listener: self)
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
                 //  self.setChart()
                print("history",self.rainLastDays)
                self.setRainLabel()
               }
            
              }
           let request = WeatherAPI.requestWeather(latitude: lat, longitude: lon)
           request.responseJSON {
               data in
               let jsonResponse = JSON(data.value!)
               let dayRain = WeatherAPI.calculateForeRainSum(jsonResponse: jsonResponse)
               print("forecast ",dayRain)
               self.rainForeDays = dayRain
               
               self.rainDays.merge(self.rainForeDays) { (new, _) in new }
             //  self.setChart()
            self.setRainLabel()
             
           }
                
    
          }
    
    private func configureLocationServices() {
                   locationManager.delegate = self
                   let status = CLLocationManager.authorizationStatus()
        if  status == .notDetermined || status == .denied {
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
    
    private func setRainLabel() {
        var rainSum = 0.0
        for r in rainDays.values{
            rainSum = rainSum + r
        }
       
        self.rainSumLabel.text = "Total Rainfall in 7 days: \(rainSum.round(to: 2))"
        
        progressDict["rain"] = Int(rainSum)
           NotificationCenter.default.post(name: NSNotification.Name("progressChange"), object: nil,userInfo: progressDict)
    }
    
    

    
}

