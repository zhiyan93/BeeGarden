//
//  PlantDetailVC.swift
//  BeeGarden
//
//  Created by steven liu on 25/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import SwiftEntryKit
import SafariServices

class PlantDetailVC: UIViewController,DatabaseListener, SFSafariViewControllerDelegate {
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
    
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var monthBlock: UILabel!
    
    @IBOutlet weak var monthView: UIView!
    
    
    
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
        
        monthView.layer.cornerRadius = 10
        monthView.setMyBorderColor()
        
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
                        TopNotesPush.push(message: "Added \(selectedPlant!.name ?? " ") to your garden", color: .color(color: Color.LightBlue.a700))
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
    
    
    
    @IBAction func climateInfoAct(_ sender: Any) {
        let urlString = "https://www.abcb.gov.au/Resources/Tools-Calculators/Climate-Zone-Map-Victoria"

               if let url = URL(string: urlString) {
                          let vc = SFSafariViewController(url: url)
                          vc.delegate = self

                          present(vc, animated: true)
                      }
    }
    
    
    @IBAction func nectarInfoAct(_ sender: Any) {
        if self.nectarLab.text == "Low nectar" {
           TopNotesPush.centreFloatPush(title: "Low nectar", desc: "Nectar is an attracting agent for bees. It is sweetened liquid produced by the plant as a compensation for pollination. As plants being immobile need pollinating animals (bees, butterflies, ants, moths) for transferring their pollens from flower to flower to reproduce. The nectar is produced as a reward for those animals as a gift. It not only consists of sugar but also of amino acids, vitamins and essential oils. Different plants have varied levels of nectar in them varying from 8-50%. The production of nectar depends on the size of the flower, time of the year and the ambient temperature. Tip: Plant more flowers of these kind to attract greater number of bees to your backyard garden.", image: UIImage(named: "nectar-low"))
        }
        
        else {
             TopNotesPush.centreFloatPush(title: "High nectar", desc: "Nectar is an attracting agent for bees and is a source of energy for all the day-to-day activities. It is sweetened liquid produced by the plant as a compensation for pollination. As plants being immobile need pollinating animals (bees, butterflies, ants, moths) for transferring their pollens from flower to flower to reproduce. Different plants have varied levels of nectar in them varying from 8-50%. The production of nectar depends on the size of the flower, time of the year and the ambient temperature. Bees prefer plants with high nectar as the amino acids present in the nectar might assist the bees as a fuel for their flight. The higher the quantity of nectar the greater number of bees might visit the plants. Additionally, at high levels of nectar, other things such as visual cues and physical clues (keeping display of varied colours of plants) and periodic availability of plants", image: UIImage(named: "nectar-high"))
        }
        
        
        
        
    }
    
    
    @IBAction func pollenInfoAct(_ sender: Any) {
        
        if self.pollenLab.text == "Low pollen" {
            TopNotesPush.centreFloatPush(title: "Low pollen", desc: "Pollination problems include reduced production and small or misshapen fruit. Assessing the degree of pollination and identifying problems can be difficult because other factors can also cause these symptoms. For example, lower than expected yield can be due to low flower numbers, disease, nutrition, or water. Likewise, misshapen fruit might be a sign of poor pollination or of a disease affecting the ovary. Coming to the wrong conclusion about a pollination problem can be both expensive and frustrating.\n Poor pollination results in deformed fruits that often drop off before maturing.", image: UIImage(named: "pollen-low"))
        }
        else {
            TopNotesPush.centreFloatPush(title: "High pollen", desc: "Assessing the amount of pollination a crop is receiving can be a very valuable management tool to indicate whether pollination is optimized or can be improved. It is common for growers to know the production they receive from their crop in terms of kg, trays, or boxes per hectare. Although this will be related to the amount of pollination, it is also heavily influenced by the numbers of plants, flowers, and the numbers of fruit or seeds lost through thinning, damage or disease.\n Good pollination results in large, healthy fruits with viable seeds.", image: UIImage(named: "pollen-high"))
        }
    }
    
    
    @IBAction func monthInfoBtn(_ sender: Any) {
        TopNotesPush.centreFloatPush(title: "Flowering Months" , desc: "Flowering of any plant is heavily dependent on the temperature and time of the year.These are the onset months for when the flowering of the plant starts.", image: UIImage(named: "flowerinfo"))
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
      
        var monthString = ""
        for m in months! {
            print(m)
            guard let indexm = Int(m)  else {return}
                print("indexm ",indexm)
           
                let subViewOfSegment: UIView = monthSegment.subviews[indexm - 1] as UIView
                subViewOfSegment.backgroundColor = .systemOrange
            
          
            monthString.append(switchMonth(monthIndex:indexm))
        }
        
     
        
        self.monthLabel.text = monthString
        self.monthLabel.fitTextToBounds()
        
        self.monthBlock.text = monthString
        self.monthBlock.fitTextToBounds()
        
           self.monthSegment.selectedSegmentIndex = currentMonth - 1
              
           
        if selectedPlant?.nectar == "low"{
            self.nectarImage.image = UIImage(named: "nectar-low")
            self.nectarLab.text = "Low nectar"
        }
        else {
             self.nectarImage.image = UIImage(named: "nectar-high")
                       self.nectarLab.text = "High nectar"
        }
        
        
        if selectedPlant?.pollen == "low"{
            pollenImage.image = UIImage(named: "pollen-low")
            pollenLab.text = "Low pollen"
        }
        else{
           pollenImage.image = UIImage(named: "pollen-high")
                       pollenLab.text = "High pollen"
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
    
    func switchMonth(monthIndex :Int) -> String {
        var monthString = ""
        switch monthIndex {
                  case 1: monthString.append("  January\n")
                  case 2: monthString.append("  February\n")
                  case 3: monthString.append("  March\n")
                  case 4: monthString.append("  April\n")
                  case 5: monthString.append("  May\n")
                  case 6: monthString.append("  June\n")
                  case 7: monthString.append("  July\n")
                  case 8: monthString.append("  August\n")
                  case 9: monthString.append("  September\n")
                  case 10: monthString.append("  October\n")
                  case 11: monthString.append("  November\n")
                  case 12: monthString.append("  December\n")
                  default:
                      monthString.append("  Jan.")
                  }
        
        return monthString
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
