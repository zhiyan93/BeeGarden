//
//  GardenPlantHSVC.swift
//  BeeGarden
//
//  Created by steven liu on 25/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CoreData

class GardenPlantHSVC: UIViewController, DatabaseListener {
    var listenerType = ListenerType.garden
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
    
    // MARK: - Constants
     
     let cellWidth = (0.7) * UIScreen.main.bounds.width
   // let cellHeigth =
     let sectionSpacing = (1 / 16) * UIScreen.main.bounds.width
     let cellSpacing = (1 / 16) * UIScreen.main.bounds.width
     
    // let colors: [UIColor] = [.red, .green, .blue, .purple, .orange, .black, .cyan]
     let cellId = "cell id"
    
     // MARK: - UI Components
     var imageList = [UIImage]()
     var managedObjectContext: NSManagedObjectContext?
     
     lazy var collectionView: UICollectionView = {
         let layout =  PagingCollectionViewLayout()
         layout.scrollDirection = .horizontal
         layout.sectionInset = UIEdgeInsets(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
         layout.itemSize = CGSize(width: cellWidth * 0.6, height: cellWidth * 0.65)  //0.9
         layout.minimumLineSpacing = cellSpacing
         
        
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         collectionView.showsHorizontalScrollIndicator = false
         collectionView.backgroundColor = UIColor.clear
         collectionView.decelerationRate = .fast
         collectionView.dataSource = self
         collectionView.delegate = self
       
         return collectionView
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                     databaseController = appDelegate.databaseController   //coredata
        
      design()
                registerCollectionViewCells()
                applyConstraints()
        
     //receive datareload notification
       NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func loadList(notification: NSNotification) {
      self.collectionView.reloadData()
    }
    

    override func viewWillAppear(_ animated: Bool) {
                    super.viewWillAppear(animated)
                 databaseController?.addListener(listener: self)
           
          // let res =  databaseController?.addPlantToGarden(plant:  plants[0], garden: databaseController!.defaultGarden)
           //       print(res)
       // collectionView.reloadData()
    
        
            print("garden plants: ",gardenPlants.count)
        
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

    private func design() {
               view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
       
           }
           
           private func registerCollectionViewCells() {
               collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
               collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "addCellId")
           }
           
           private func applyConstraints() {
               view.addSubview(collectionView)
               collectionView.centerXAnchor .constraint(equalTo: view.centerXAnchor).isActive = true
              // collectionView.centerYAnchor .constraint(equalTo: view.centerYAnchor).isActive = true
               collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
               collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
               collectionView.heightAnchor.constraint(equalToConstant: cellWidth * 0.7 ).isActive = true
           }
}

extension GardenPlantHSVC: UICollectionViewDataSource, UICollectionViewDelegate {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return (gardenPlants.count + 1)
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCellId", for: indexPath)
              
            if indexPath.item != 0
            {
                let plant = gardenPlants[indexPath.item - 1]
                //            imageLabel.text = bee.name
                //            imageLabel.textAlignment = .center
                            let img : UIImage = UIImage(data: plant.image! as Data)!
                        
                        //    imageview.image = img
                            
                        let myImageView:UIImageView = UIImageView()
                myImageView.frame.size.width = cellWidth * 0.6   //0.9
                            myImageView.frame.size.height = cellWidth * 0.65
                          //  myImageView.frame.offsetBy(dx: -40, dy: 20)
                            myImageView.frame = myImageView.frame.offsetBy(dx: 0, dy: 0)
                          //  myImageView.center = self.view.center
                            myImageView.image = img
                             myImageView.layer.cornerRadius = 20 // change this number to get the corners you want
                             myImageView.layer.masksToBounds = true
                myImageView.contentMode = .scaleAspectFill
                            cell.contentView.addSubview(myImageView)
                       return cell
            }
            
            
            if indexPath.item == 0 {
                let img : UIImage = UIImage(named: "plus128p")!
                let myImageView:UIImageView = UIImageView()
                  myImageView.frame.size.width = cellWidth * 0.3
                  myImageView.frame.size.height = cellWidth * 0.3
                //  myImageView.frame.offsetBy(dx: -40, dy: 20)
                  myImageView.frame = myImageView.frame.offsetBy(dx: 0, dy: 50)
                //  myImageView.center = self.view.center
                  myImageView.image = img
                   myImageView.layer.cornerRadius = 20 // change this number to get the corners you want
                   myImageView.layer.masksToBounds = true

                  addCell.contentView.addSubview(myImageView)
                  return addCell
            }
            return cell
              
                
            }
                
           
           
                
          
            
            
          //  cell.contentView.addSubview(imageLabel)
        
        
        
    
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            print("garden plant \(indexPath.item) selected")
         // let beeDetail = storyboard?.instantiateViewController(withIdentifier: "beeDetail") as! HomeBeeDetailVC
          //  beeDetail.selectedBee = bees[indexPath.item]
    
          
            
            if indexPath.item == 0 {
                let plantList = storyboard?.instantiateViewController(withIdentifier: "plantListBView") as! PlantListBVC
                 present(plantList, animated: true)
            }
            else {
                let plantDetail = storyboard?.instantiateViewController(withIdentifier: "plantDetailView") as! PlantDetailVC
                               plantDetail.selectedPlant = gardenPlants[indexPath.item - 1]
                               plantDetail.showNotAdd = true
                               present(plantDetail, animated: true)
                         
                           collectionView.deselectItem(at: indexPath, animated: true)
            }
            
           
               
        }
        
      
        
        
       
    }

extension GardenPlantHSVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        if indexPath.item == 0 {
            return CGSize(width: cellWidth * 0.3, height: cellWidth * 0.65)
        }
          return CGSize(width: cellWidth * 0.6, height: cellWidth * 0.65)  //0.9
    }


}
