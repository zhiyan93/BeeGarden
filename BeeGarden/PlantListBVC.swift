//
//  PlantListBVC.swift
//  BeeGarden
//
//  Created by steven liu on 14/5/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class PlantListBVC: UIViewController,DatabaseListener {
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
        plants = flowersDB
              
               for p in plants{
                   plantNames.append(p.name ?? "defalut name")
               }
    }
    
    func onRecordListChange(change: DatabaseChange, recordsDB: [PlantRecordEntity]) {
        
    }
    
    func onGardenChange(change: DatabaseChange, gardenPlants: [FlowerEntity]) {
        
    }
    
    var plants = [FlowerEntity]()
       var plantNames = [String]()
       var selectedPlant : FlowerEntity?
       var collectionView: UICollectionView!
       var items = ["herb","shrub","tree"]
       var herbList = [Int]()
       var shrubList = [Int]()
       var treeList = [Int]()
    let cellReuseId = "plantCellReId"
    var sectionState : Int = 0
    
weak var databaseController : DatabaseProtocol?
    
   
    
    @IBOutlet weak var categroySegment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var plantIcon: UIImageView!
    
    @IBOutlet weak var plantIconL: UIImageView!
    
    @IBOutlet weak var plantIconR: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
              databaseController = appDelegate.databaseController   //coredata
        
        // Register the table view cell class and its reuse id
       // self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
       self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
      //  plantIcon.makeRounded()
        plantIconL.image = UIImage(named: "herbimg")!
        plantIcon.image = UIImage(named: "shrubimg")!
        plantIconR.image = UIImage(named: "treeimg")!
        
        showPlantIcon(iconNum: 0)
        
        let font = UIFont.boldSystemFont(ofSize: 18)  //systemFont(ofSize: 18)

           let normalAttribute: [NSAttributedString.Key: Any] = [.font: font]
           categroySegment.setTitleTextAttributes(normalAttribute, for: .normal)

           let selectedAttribute: [NSAttributedString.Key: Any] = [.font: font]  // .foregroundColor: UIColor.red
           categroySegment.setTitleTextAttributes(selectedAttribute, for: .selected)
    
        
    }
    
    func showPlantIcon(iconNum : Int) {
        switch iconNum {
        case 0:
            self.plantIconL.isHidden = false
             self.plantIcon.isHidden = true
             self.plantIconR.isHidden = true
        case 1 :
            self.plantIconL.isHidden = true
            self.plantIcon.isHidden = false
            self.plantIconR.isHidden = true
        default:
            self.plantIconL.isHidden = true
            self.plantIcon.isHidden = true
            self.plantIconR.isHidden = false
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
         databaseController?.addListener(listener: self)
        herbList = [Int]()
        shrubList = [Int]()
        treeList = [Int]()
        categoryEntity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    @IBAction func categroySegAct(_ sender: Any) {
        switch self.categroySegment.selectedSegmentIndex {
               case 0: print("segment 0")
               showPlantIcon(iconNum: 0)
               case 1: print("segment 1")
               showPlantIcon(iconNum: 1)
               case 2: print("segment 2")
               showPlantIcon(iconNum: 2)
               default:
                   print("segment default")
                  showPlantIcon(iconNum: 2)
               }
        
        self.sectionState = self.categroySegment.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    
    
    
    private func sectionPlants(sectionNum: Int) -> [Int] {
           if items[sectionNum] == "herb"{
               return herbList
           }
           else if items[sectionNum] == "shrub"{
               return shrubList
           }
           else if items[sectionNum] == "tree"{
               return treeList
           }
           return [Int]()
       }
    
    
    private func categoryEntity() {
        var i: Int = 0
        while i<plants.count {
           let p = plants[i]
            if p.category == "herb"{
                herbList.append(i)
            }
            else if p.category == "shrub"{
                shrubList.append(i)
            }
            else if p.category == "tree"{
                treeList.append(i)
            }
             i = i+1
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

}

extension PlantListBVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var res : Int = 0
        switch sectionState {
        case 0:
            res = herbList.count
        case 1: res = shrubList.count
        case 2 : res = treeList.count
        default:
            res = herbList.count
        }
        
        
        return res
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plantListCell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! PlantsTableViewCell
        let plantIndex = sectionPlants(sectionNum: sectionState)[indexPath.row]
        let originImage = UIImage(data:  plants[plantIndex].image! )
        plantListCell.plantImage.image = originImage
            
        plantListCell.plantName.text = " " + (plants[plantIndex].name ?? " ") + " "
        
     
        plantListCell.plantName.fitTextToBounds()
        
        
        return plantListCell
    }
    
//   func addBlurTo(_ image: UIImage) -> UIImage? {
//        guard let ciImg = CIImage(image: image) else { return nil }
//        let blur = CIFilter(name: "CIGaussianBlur")
//        blur?.setValue(ciImg, forKey: kCIInputImageKey)
//        blur?.setValue(5.0, forKey: kCIInputRadiusKey)
//
//        if let outputImg = blur?.outputImage {
//            return UIImage(ciImage: outputImg)
//        }
//        return image
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select \(indexPath.row)")
        let plantIndex = sectionPlants(sectionNum: sectionState)[indexPath.row]
        
        let plantView = storyboard?.instantiateViewController(withIdentifier: "plantDetailView") as! PlantDetailVC
        let plant = plants[plantIndex]
        print(plant.name!)
        plantView.selectedPlant = plant
        present(plantView, animated: true )
        
    }
    
    
}
