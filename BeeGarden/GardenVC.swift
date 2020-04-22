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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               databaseController = appDelegate.databaseController   //coredata
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
                 super.viewWillAppear(animated)
              databaseController?.addListener(listener: self)
        
       // let res =  databaseController?.addPlantToGarden(plant:  plants[0], garden: databaseController!.defaultGarden)
        //       print(res)
        
        print(gardenPlants.count)
              
          }
       
       
       override func viewWillDisappear(_ animated: Bool) {
                 super.viewWillDisappear(animated)
                 databaseController?.removeListener(listener: self)
           
          
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
