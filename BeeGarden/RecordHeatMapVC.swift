//
//  RecordHeatMapVC.swift
//  BeeGarden
//
//  Created by steven liu on 26/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CalendarHeatmap
import SwiftEntryKit

class RecordHeatMapVC: UIViewController, CalendarHeatmapDelegate,DatabaseListener,UIViewControllerTransitioningDelegate{
    var listenerType = ListenerType.plantRecord
    weak var databaseController : DatabaseProtocol?
    
    var recordDates = [DateComponents]()
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
    
    var records = [PlantRecordEntity]()

    lazy var calendarHeatMap: CalendarHeatmap = {
           var config = CalendarHeatmapConfig()
           config.backgroundColor = UIColor.systemBackground
           // config item
           config.selectedItemBorderColor = .orange
           config.allowItemSelection = true
           // config month header
           config.monthHeight = 30
           config.monthStrings = DateFormatter().shortMonthSymbols
           config.monthFont = UIFont.systemFont(ofSize: 18)
           config.monthColor = UIColor.label
           // config weekday label on left
           config.weekDayFont = UIFont.systemFont(ofSize: 13)
           config.weekDayWidth = 30
           config.weekDayColor = UIColor.label
           
         //  let dateFormatter = DateFormatter()
          // dateFormatter.dateFormat = "yyyy-MM-dd"
          // let sDay = dateFormatter.date(from: "2020-02-01 ")!
          // let eDay = dateFormatter.date(from: "2020-04-26")!
        let monthAgo = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        let agoComponents = Calendar.current.dateComponents([.year, .month, .day], from: monthAgo!)
        
        let sDay = DateComponents(calendar: Calendar.current, year: agoComponents.year, month: agoComponents.month!, day: 1)
           
        let calendar = CalendarHeatmap(config: config, startDate: sDay.date!, endDate: Date())
           calendar.delegate = self
           return calendar
       }()
    
     var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController   //coredata
        
          // provide a range of date.
        view.backgroundColor = UIColor(named: "background")
        calendarHeatMap.layer.cornerRadius = 10
                           view.addSubview(calendarHeatMap)
                           calendarHeatMap.translatesAutoresizingMaskIntoConstraints = false
                           
                           NSLayoutConstraint.activate([
                               calendarHeatMap.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 2),
                               calendarHeatMap.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
                               calendarHeatMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
                            calendarHeatMap.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 2)
                           ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(addWatering(notification:)), name: NSNotification.Name(rawValue: "addWatering"), object: nil)
        
        
        view.setMyBorderColor()
        view.layer.cornerRadius = 15
        
//        NotificationCenter.default.addObserver(self, selector: #selector(addWateringRecord(notification:)), name: NSNotification.Name(rawValue: "addMyWateringRecord"), object: nil)
    
    }
    
    @objc func addWatering(notification: NSNotification) {
          //  self.collectionView.reloadData()
       let indexInfo = notification.userInfo
      //  print("indexInfo",indexInfo)
       print("value", indexInfo![1])
        var waterCount = 1
        waterCount = indexInfo![1] as! Int + 1
        let name = "watering" + String(waterCount)
        let nowComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        if recordDates.contains(nowComponents){
           let index = recordDates.firstIndex(of: nowComponents)
            databaseController?.deleteRecord(record: records[index!])
        }
       let _ = databaseController?.addRecord(name: name, type: "watering", time: Date(), counting: waterCount)
        print("records: ",records.count)
        calendarHeatMap.reload()
        
        
        
         let dictionary = [1:get4dayRecord()]
         NotificationCenter.default.post(name: NSNotification.Name("recordChange"), object: nil,userInfo: dictionary)
        
          }
    
//    @objc func addWateringRecord(notification: NSNotification){
//        TopNotesPush.ratingPush()
//    }
    
    private func get4dayRecord() -> Double {
        let pnday = NSCalendar.current.date(byAdding: .day, value: -4, to: Date())
//        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: pnday ?? Date())
        var recordSum = 0.0
        
        for r in records{
            if r.time! > pnday ?? Date() {
                switch r.counting {
                           case 1 : recordSum = recordSum + 2.5
                           case 2 : recordSum = recordSum + 7.5
                           case 3 : recordSum = recordSum + 12.5
                           case 4 : recordSum = recordSum + 17.5
                           case 5 : recordSum = recordSum + 22.5
                           default:
                               recordSum = recordSum + 2.5
                           }
            }
            else {
                break
            }
           
            
        }
    print("recordsSum",recordSum)
    return recordSum
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
                    super.viewWillAppear(animated)
                 databaseController?.addListener(listener: self)
            print("garden records: ",records.count)
        

        let dictionary = [1:get4dayRecord()]
                NotificationCenter.default.post(name: NSNotification.Name("recordChange"), object: nil,userInfo: dictionary)
             }
    
    override func viewWillDisappear(_ animated: Bool) {
                      super.viewWillDisappear(animated)
                      databaseController?.removeListener(listener: self)
                
               
                  }
    

    func colorFor(dateComponents: DateComponents) -> UIColor {
           guard let year = dateComponents.year,
               let month = dateComponents.month,
               let day = dateComponents.day else { return .clear}
           // manage your color based on date here
        var yourColor = UIColor.systemGray3.withAlphaComponent(0.6)
        let now = Date()
        let nowComponents = Calendar.current.dateComponents([.year, .month, .day], from: now)
        if nowComponents == dateComponents{
            yourColor = .systemOrange
        }
        
      
        recordDates = [DateComponents]()
        for r in records {
           let rDate = r.time
            let rComponents = Calendar.current.dateComponents([.year, .month, .day], from: rDate ?? Date())
            recordDates.append(rComponents)
            if dateComponents == rComponents {
                switch r.counting {
                case 1 : yourColor = UIColor(named: "wateringColor1")!
                case 2 : yourColor = UIColor(named: "wateringColor2")!
                case 3 : yourColor = UIColor(named: "wateringColor3")!
                case 4 : yourColor = UIColor(named: "wateringColor4")!
                case 5 : yourColor = UIColor(named: "wateringColor5")!
                default:
                    yourColor =  UIColor(named: "wateringColor1")!
                }
            }
        }
           return yourColor
       }
    
    // (optional) selection at date
       func didSelectedAt(dateComponents: DateComponents) {
           guard let year = dateComponents.year,
           let month = dateComponents.month,
           let day = dateComponents.day else { return }
           // do something here
        let nowComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
               if nowComponents == dateComponents{
//                let addRVC = storyboard?.instantiateViewController(withIdentifier: "addRecordView") as! addRecordVC
//                 self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: addRVC)
//                addRVC.modalPresentationStyle = .custom
//                addRVC.transitioningDelegate = self.halfModalTransitioningDelegate

               // addRVC.transitioningDelegate = self
              //    present(addRVC, animated: true)
                TopNotesPush.ratingPush()
               }
        var i:Int = 0
        while i < recordDates.count{
            if recordDates[i] == dateComponents,dateComponents != nowComponents{
                let waterCountValue = records[i].counting
                var title:String = ""
                switch waterCountValue {
                case 1 : title = "Slightly watering"
                case 2 : title = "Moisture watering"
                case 3 : title = "Moderate watering"
                case 4 : title = "Enough watering"
                case 5 : title = "Extra watering"
                default : title = "Slightly watering"
                }
              
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let d = formatter.string(from: records[i].time!)
                TopNotesPush.bottomPush(message: d, title: title , icon: UIImage(named: "drop128p")!, color: .greenGrass)
            }
            i = i+1
        }
        
       }
    


       // (optional) notify finish loading the calendar
       func finishLoadCalendar() {
           // do something here

       }
    
    
//   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           super.prepare(for: segue, sender: sender)
//
//           self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
//
//           segue.destination.modalPresentationStyle = .custom
//           segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
//       }

}
