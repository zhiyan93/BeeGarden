//
//  NavTabVC.swift
//  BeeGarden
//
//  Created by steven liu on 21/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class NavTabVC: UIViewController,DatabaseListener {
    var listenerType = ListenerType.flower
    
    func onObserveListChange(change: DatabaseChange, observesDB: [ObserveEntity]) {
        
    }
    
    func onBeeListChange(change: DatabaseChange, beesDB: [BeeEntity]) {
        
    }
    
    func onKnowledgeListChange(change: DatabaseChange, knowsDB: [KnowledgeEntity]) {
        
    }
    
    func onSpotListChange(change: DatabaseChange, spotsDB: [SpotEntity]) {
        
    }
    
    func onFlowerListChange(change: DatabaseChange, flowersDB: [FlowerEntity]) {
        flowers = flowersDB
    }
    
    func onRecordListChange(change: DatabaseChange, recordsDB: [PlantRecordEntity]) {
        
    }
    weak var databaseController : DatabaseProtocol?

    var flowers = [FlowerEntity]()
   
    @IBOutlet weak var PlantCount: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController   //coredata
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
           databaseController?.addListener(listener: self)
        
         PlantCount.text = String(flowers.count)
           
       }
    
    override func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(animated)
              databaseController?.removeListener(listener: self)
          }
    
    @IBAction func addPlantBtn(_ sender: Any) {
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabBarVC
        tabBar.selectedIndex = 1
            present(tabBar, animated: true, completion: nil)
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
