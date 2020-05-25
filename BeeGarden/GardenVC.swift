//
//  GardenVC.swift
//  BeeGarden
//
//  Created by steven liu on 23/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class GardenVC: UIViewController ,DatabaseListener{
    var listenerType =  ListenerType.garden
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
        self.plants = flowersDB
    }
    
    func onRecordListChange(change: DatabaseChange, recordsDB: [PlantRecordEntity]) {
        
    }
    
    func onGardenChange(change: DatabaseChange, gardenPlants: [FlowerEntity]) {
        self.gardenPlants = gardenPlants
    }
    
    var gardenPlants = [FlowerEntity]()
    var plants = [FlowerEntity]()
    
    @IBOutlet weak var plantContainer: UIView!
    
     @IBOutlet var gardenView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var addRecordBtn: UIButton!
    
    let tips = [
        ("Don’t use pesticides","Most pesticides are not selective. By using pesticides, one risks killing off the beneficial insects along with the pests. If you must use a pesticide, start with the least toxic one and follow the label instructions to the letter."),
        ("Use local native plants" , "Many native plants are very attractive to honeybees. They are also usually well adapted to your growing conditions and can thrive with minimum attention. In gardens, heirloom varieties of herbs and perennials should be used. Single-flower varieties may also provide good foraging."),
        ( "Use a range of colours","Bees have good colour vision to help them find flowers and the nectar and pollen they offer. Flower colours that particularly attract bees are blue, purple, violet, white and yellow."),
        ("Plant flowers in clumps","Flowers clustered into clumps of one species will attract more pollinators than individual plants scattered through the habitat patch. Where space allows, make the clumps 1 m or more in diameter."),
        ("Include flowers of different shapes","Open or cup-shaped flowers provide the easiest access and shorter floral tubes are important for honeybees. Other pollinators, including native bees, butterflies and birds, benefit from differing flower shapes."),
        ("Have a diversity of plants, flowering all season","A varied diet is essential for the well- being of honeybees and other pollinators."),
        ("Plant where bees will visit","Bees favour sunny spots over shade and need some shelter from strong winds."),
        ("Provide accessible water","Bees need access to water. Provide easy access, either through wet sand or pebbles; do not drown the bees.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               databaseController = appDelegate.databaseController   //coredata
        
        plantContainer.layer.cornerRadius = 15
      //  gardenView.backgroundColor = .systemOrange
      //  contentView.backgroundColor = .systemOrange
        plantContainer.setMyBorderColor()
        
        
        // let lastTipDate = UserDefaults.standard.object(forKey: "lastTipDay") as? Date
                             
                                     //      UserDefaults.standard.set(Date(), forKey: "lastTipDay")
            let randIndex = Int.random(in: 0...(tips.count-1))
              let randTip = tips[randIndex]
              TopNotesPush.centreFloatPush(title: randTip.0, desc: randTip.1, image: UIImage(named: "lighting-bulb"))
                                       
                                
                               
                                //    let lastTipDayDiff = Calendar.current.dateComponents([.day], from: lastTipDate ?? Date(), to: Date()).day!
                                    print("tip diff")
                               //     if lastTipDayDiff > 0 {
                             //           UserDefaults.standard.set(Date(), forKey: "lastTipDay")
        addRecordBtn.layer.cornerRadius = 10
        
    }
   
    
    
    override func viewWillAppear(_ animated: Bool) {
                 super.viewWillAppear(animated)
              databaseController?.addListener(listener: self)
        
       // let res =  databaseController?.addPlantToGarden(plant:  plants[0], garden: databaseController!.defaultGarden)
        //       print(res)
        
        print(gardenPlants.count)
              
          }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
       
    }
    
    func displayMessage(title: String, message: String) {
         
           let alertController = UIAlertController(title: title, message: message, preferredStyle:
               UIAlertController.Style.alert)
           alertController.addAction(UIAlertAction(title: "Get it!", style: UIAlertAction.Style.default,handler:
               nil))
           self.present(alertController, animated: true, completion: nil)
       }
       
       
     override func viewWillDisappear(_ animated: Bool) {
                    super.viewWillDisappear(animated)
                    databaseController?.removeListener(listener: self)
              
             
                }
    
    
    
    @IBAction func addRecordAct(_ sender: Any) {
       // NotificationCenter.default.post(name: NSNotification.Name("addMyWateringRecord"), object: nil)
        TopNotesPush.ratingPush()
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
