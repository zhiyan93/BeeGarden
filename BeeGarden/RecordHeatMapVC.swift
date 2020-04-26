//
//  RecordHeatMapVC.swift
//  BeeGarden
//
//  Created by steven liu on 26/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CalendarHeatmap

class RecordHeatMapVC: UIViewController, CalendarHeatmapDelegate,DatabaseListener, UIViewControllerTransitioningDelegate {
    var listenerType = ListenerType.plantRecord
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
    
    var records = [PlantRecordEntity]()

    lazy var calendarHeatMap: CalendarHeatmap = {
           var config = CalendarHeatmapConfig()
           config.backgroundColor = UIColor.white
           // config item
           config.selectedItemBorderColor = .orange
           config.allowItemSelection = true
           // config month header
           config.monthHeight = 30
           config.monthStrings = DateFormatter().shortMonthSymbols
           config.monthFont = UIFont.systemFont(ofSize: 18)
           config.monthColor = UIColor.black
           // config weekday label on left
           config.weekDayFont = UIFont.systemFont(ofSize: 13)
           config.weekDayWidth = 30
           config.weekDayColor = UIColor.black
           
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
                               calendarHeatMap.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 1),
                               calendarHeatMap.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1),
                               calendarHeatMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2)
                           ])
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
                    super.viewWillAppear(animated)
                 databaseController?.addListener(listener: self)
            print("garden records: ",records.count)
        
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
       var yourColor = UIColor.gray
        let now = Date()
        let nowComponents = Calendar.current.dateComponents([.year, .month, .day], from: now)
        if nowComponents == dateComponents{
            yourColor = .cyan
        }
        
      
      
        for r in records {
           let rDate = r.time
            let rComponents = Calendar.current.dateComponents([.year, .month, .day], from: rDate ?? Date())
            if dateComponents == rComponents {
                yourColor = .systemBlue
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
                let addRVC = storyboard?.instantiateViewController(withIdentifier: "addRecordView") as! addRecordVC
              // let addRVC = addRecordVC()
                addRVC.transitioningDelegate = self
                addRVC.modalPresentationStyle = .custom
                  present(addRVC, animated: true)
               }
        
       }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    class HalfSizePresentationController : UIPresentationController {
        override var frameOfPresentedViewInContainerView: CGRect {
            get {
                guard let theView = containerView else {
                    return CGRect.zero
                }

                return CGRect(x: 0, y: theView.bounds.height/2, width: theView.bounds.width, height: theView.bounds.height/2)
            }
        }
    }

       // (optional) notify finish loading the calendar
       func finishLoadCalendar() {
           // do something here
      
             
              
             
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
