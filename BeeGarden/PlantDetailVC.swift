//
//  PlantDetailVC.swift
//  BeeGarden
//
//  Created by steven liu on 25/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import SwiftEntryKit

class PlantDetailVC: UIViewController,DatabaseListener {
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
        
    }
    
    func onRecordListChange(change: DatabaseChange, recordsDB: [PlantRecordEntity]) {
        
    }
    
    func onGardenChange(change: DatabaseChange, gardenPlants: [FlowerEntity]) {
        self.gPlants = gardenPlants
    }
    

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descField: UITextView!
    
    @IBOutlet weak var climateSegment: UISegmentedControl!
    
    @IBOutlet weak var monthSegment: UISegmentedControl!
    
    @IBOutlet weak var nectarSegment: UISegmentedControl!
    
    @IBOutlet weak var pollenSegment: UISegmentedControl!
    
    
    @IBOutlet weak var recommandSegment: UISegmentedControl!
    
    @IBOutlet weak var plantBtn: UIButton!
    
    var selectedPlant: FlowerEntity?
    let climateColors :[UIColor] = [.systemOrange ,.systemOrange,.systemOrange,.systemOrange]
     var gPlants = [FlowerEntity]()
    
    var showNotAdd : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController   //coredata
        changeValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
                       super.viewWillDisappear(animated)
                       databaseController?.removeListener(listener: self)
                 
                
                   }
    
    
    
    @IBAction func plantBtnAct(_ sender: Any) {
        let res =  databaseController?.addPlantToGarden(plant:  selectedPlant!, garden: databaseController!.defaultGarden)
        print("add plant to garden \(res ?? false)")
//         let gardenView = storyboard?.instantiateViewController(withIdentifier: "gardenPlantHSView") as! GardenPlantHSVC
        if(res == true){
            TopNotesPush.push(message: "add \(selectedPlant!.name ?? " ") successfully", color: .color(color: Color.LightBlue.a700))
        }
        
        else{
            TopNotesPush.push(message: "\(selectedPlant!.name ?? " ") has been in your garden", color: .color(color: Color.LightPink.first))
        }
        
        // reload the collection view
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
//        let indexPath = IndexPath(item: 0, section: 0)
        
        
        dismiss(animated: true )
    }
    
    
    
    private func changeValue(){
        self.nameLabel.text = selectedPlant?.name
        self.imageView.image = UIImage(data:  (selectedPlant?.image)!)
        self.descField.text = selectedPlant?.desc
        var climate = 0
        var climateColor = UIColor.green
        switch selectedPlant?.gclimate {
        case "Cool": climate = 0;  climateColor = climateColors[0]
        case "Temperate": climate = 1 ; climateColor = climateColors[1]
        case "Warm": climate = 2 ; climateColor = climateColors[2]
        case "Hot": climate = 3 ; climateColor = climateColors[3]
        default:
            climate = 0 ; climateColor = climateColors[0]
        }
        self.climateSegment.selectedSegmentIndex = climate
        self.climateSegment.selectedSegmentTintColor = climateColor
        
        let calendar = Calendar.current
       let currentMonth = calendar.component(.month, from: Date())
        print("currentm ",currentMonth)
    
        let months = selectedPlant?.gmonth!.split(separator: ",")
      
        for m in months! {
            print(m)
            guard let indexm = Int(m)  else {return}
                print("indexm ",indexm)
           
                let subViewOfSegment: UIView = monthSegment.subviews[indexm - 1] as UIView
                subViewOfSegment.backgroundColor = .systemOrange
            
          
            
        }
        
           self.monthSegment.selectedSegmentIndex = currentMonth - 1
              
           
        if selectedPlant?.nectar == "low"{
            self.nectarSegment.selectedSegmentIndex = 0
        }
        else {
            self.nectarSegment.selectedSegmentIndex = 1
        }
        nectarSegment.selectedSegmentTintColor = .systemOrange
        
        if selectedPlant?.pollen == "low"{
            self.pollenSegment.selectedSegmentIndex = 0
        }
        else{
            self.pollenSegment.selectedSegmentIndex = 1
        }
        pollenSegment.selectedSegmentTintColor = .systemOrange
        
        
        self.plantBtn.layer.cornerRadius = 10
        if showNotAdd == true {
            plantBtn.isEnabled = false
            plantBtn.isHidden = true
        }
       // self.plantBtn.backgroundColor = .systemOrange
        
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
