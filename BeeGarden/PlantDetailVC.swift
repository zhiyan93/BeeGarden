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
    
    
    @IBOutlet weak var monthSegment: UISegmentedControl!
    
   
    @IBOutlet weak var borderView: UIView!
    
   
    
    
    
    @IBOutlet weak var plantBtn: UIButton!
    
    @IBOutlet weak var climateView: UIView!
    
    @IBOutlet weak var climateImage: UIImageView!
    
    @IBOutlet weak var climateLab: UILabel!
    
    
    @IBOutlet weak var nectarView: UIView!
    
    @IBOutlet weak var nectarImage: UIImageView!
    
    @IBOutlet weak var nectarLab: UILabel!
    
    
    @IBOutlet weak var pollenView: UIView!
    
    @IBOutlet weak var pollenImage: UIImageView!
    
    @IBOutlet weak var pollenLab: UILabel!
    
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
        borderView.setMyBorderColor()
        borderView.layer.cornerRadius = 15
        
        climateView.layer.cornerRadius = 10
              climateView.setMyBorderColor()
        pollenView.layer.cornerRadius = 10
              pollenView.setMyBorderColor()
        nectarView.layer.cornerRadius = 10
              nectarView.setMyBorderColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
                       super.viewWillDisappear(animated)
                       databaseController?.removeListener(listener: self)
                 
                
                   }
    
    
    
    @IBAction func plantBtnAct(_ sender: Any) {
        
        if (showNotAdd == false){
                   let res =  databaseController?.addPlantToGarden(plant:  selectedPlant!, garden: databaseController!.defaultGarden)
                    print("add plant to garden \(res ?? false)")
            //         let gardenView = storyboard?.instantiateViewController(withIdentifier: "gardenPlantHSView") as! GardenPlantHSVC
                    if(res == true){
                        TopNotesPush.push(message: "Add \(selectedPlant!.name ?? " ") successfully", color: .color(color: Color.LightBlue.a700))
                    }
                    
                    else{
                        TopNotesPush.push(message: "\(selectedPlant!.name ?? " ") has been in your garden", color: .color(color: Color.LightPink.first))
                    }
        }
        
        else {
           databaseController?.removePlantFromGarden(plant: selectedPlant!, garden: databaseController!.defaultGarden)
            print("remove 1 plant from garden")
             TopNotesPush.push(message: "Remove \(selectedPlant!.name ?? " ") successfully", color: .color(color: Color.LightBlue.a700))
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
       
        var cImageName = "sun-cool"
        let cName = selectedPlant!.gclimate ?? ""
        switch selectedPlant?.gclimate {
        case "Cool":   cImageName = "sun-cool"
        case "Temperate":  cImageName = "sun-temp"
        case "Warm": cImageName = "sun-warm"
        case "Hot":  cImageName = "sun-hot"
        default:
            cImageName = "sun-cool"
        }
       //
        climateImage.image = UIImage(named: cImageName)
        climateLab.text = cName
        
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
            self.nectarImage.image = UIImage(named: "nectar-low")
            self.nectarLab.text = "low nectar"
        }
        else {
             self.nectarImage.image = UIImage(named: "nectar-high")
                       self.nectarLab.text = "high nectar"
        }
        
        
        if selectedPlant?.pollen == "low"{
            pollenImage.image = UIImage(named: "pollen-low")
            pollenLab.text = "low pollen"
        }
        else{
           pollenImage.image = UIImage(named: "pollen-high")
                       pollenLab.text = "high pollen"
        }
       
        
        
        self.plantBtn.layer.cornerRadius = 10
        if showNotAdd == true {
//            plantBtn.isEnabled = false
//            plantBtn.isHidden = true
            plantBtn.backgroundColor = .systemRed
            plantBtn.setTitle("Remove it", for: .normal)
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
