//
//  PlantListVC.swift
//  BeeGarden
//
//  Created by steven liu on 23/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import GlidingCollection
//import FloatingPanel

class PlantListVC: UIViewController,DatabaseListener {
    var listenerType = ListenerType.flower
    
    @IBOutlet weak var glidingView:  GlidingCollection!
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
    
   // var fpc: FloatingPanelController!
    
  weak var databaseController : DatabaseProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController   //coredata
        
         setup()
       //setFloatPanel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
           databaseController?.addListener(listener: self)
        
        herbList = [Int]()
        shrubList = [Int]()
        treeList = [Int]()
            categoryEntity()
        
         print(plants.count)
        print(herbList.count)
       
           
       }
       
       override func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(animated)
              databaseController?.removeListener(listener: self)
        
        // Remove the views managed by the `FloatingPanelController` object from self.view.
      //  fpc.removePanelFromParent(animated: true)
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

extension PlantListVC: GlidingCollectionDatasource {

  func numberOfItems(in collection: GlidingCollection) -> Int {
    return items.count
  }

  func glidingCollection(_ collection: GlidingCollection, itemAtIndex index: Int) -> String {
    return "– " + items[index]
  }

}

extension PlantListVC {
  
  func setup() {
    setupGlidingCollectionView()
    //loadImages()
    setupGlidingConfig()
  }
  
  private func setupGlidingCollectionView() {
    glidingView.dataSource = self
    
    let nib = UINib(nibName: "CollectionCell", bundle: nil)
    collectionView = glidingView.collectionView
    collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = glidingView.backgroundColor
  }
    private func setupGlidingConfig(){
        var config = GlidingConfig.shared
        config.cardShadowRadius = 7
        config.buttonsFont = UIFont.systemFont(ofSize: 21)
        config.cardsSize = CGSize(width: round(UIScreen.main.bounds.width * 0.65), height: round(UIScreen.main.bounds.height * 0.45))
        GlidingConfig.shared = config
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
  
}

extension PlantListVC: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
    let section = glidingView.expandedItemIndex
    //
    var res = 0
    switch items[section] {
    case "herb":
        res = herbList.count
    case "shrub":
        res = shrubList.count
    case "tree":
        res = treeList.count
    default:
        res = 0
    }
    return res
   
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
    let section = glidingView.expandedItemIndex
    //
    let plantIndex = sectionPlants(sectionNum: section)[indexPath.row]
    let image = plants[plantIndex].image
    let name = plants[plantIndex].name
    cell.imageView.image = UIImage(data: image!)
    cell.textLabel.text = name
    cell.contentView.clipsToBounds = true
    
    let layer = cell.layer
    let config = GlidingConfig.shared
    layer.shadowOffset = config.cardShadowOffset
    layer.shadowColor = config.cardShadowColor.cgColor
    layer.shadowOpacity = config.cardShadowOpacity
    layer.shadowRadius = config.cardShadowRadius
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let section = glidingView.expandedItemIndex
    let item = indexPath.item
    print("Selected item #\(item) in section #\(section)")
    let plantView = storyboard?.instantiateViewController(withIdentifier: "plantDetailView") as! PlantDetailVC
    let plantIndex = sectionPlants(sectionNum: section)[item]
    let plant = plants[plantIndex]
    print(plant.name!)
    plantView.selectedPlant = plant
    present(plantView, animated: true )
    
  }
  
}


   

//class MyFloatingPanelLayout: FloatingPanelLayout {
//    public var initialPosition: FloatingPanelPosition {
//        return .tip
//    }
//
//    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
//        switch position {
//            case .full: return 300.0 // A top inset from safe area
//            case .half: return 200.0 // A bottom inset from the safe area
//            case .tip: return 60.0 // A bottom inset from the safe area
//            default: return nil // Or `case .hidden: return nil`
//        }
//    }
//
//    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
//               return [
//                surfaceView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0.0),
//                surfaceView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 10 ),
//               ]
//           }
//}




