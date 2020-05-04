//
//  GalleryCollectionVC.swift
//  BeeGarden
//
//  Created by steven liu on 29/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CoreData


class GalleryCollectionVC: UIViewController,DatabaseListener {
    var listenerType = ListenerType.observe
    
    func onObserveListChange(change: DatabaseChange, observesDB: [ObserveEntity]) {
        observes = observesDB
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
        
    }
    

   // @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        @IBOutlet weak var collectionView: UICollectionView!
        
        @IBOutlet weak var deleteButton: UIBarButtonItem!
        //    let images = [UIImage(imageLiteralResourceName: "images"),UIImage(imageLiteralResourceName: "images1"),UIImage(imageLiteralResourceName: "images2")]

        var observes = [ObserveEntity]()
        
     weak var databaseController : DatabaseProtocol?
       // var managedObjectContext: NSManagedObjectContext?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            navigationItem.leftBarButtonItem = editButtonItem
            
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
            databaseController = appDelegate.databaseController   //coredata
            
            if let layout = collectionView.collectionViewLayout as? PinterestLayout {
                layout.delegate = self
            }
            // Do any additional setup after loading the view.
            collectionView.reloadData()
            //print("sfdfsdfdsfsdfs")
            deleteButton.isEnabled = false // modified
        }
        
      
        @IBAction func deleteAction(_ sender: Any) {
            if let selectedCells = collectionView.indexPathsForSelectedItems {
                // 1
                let items = selectedCells.map { $0.item }.sorted().reversed()
                // 2
                for item in items {
                    
                    let name :String = observes[item].name ?? " "
                   databaseController?.deleteObserve(observe: observes[item])
                    print("delete item", name)
                }
                
                // 3
                collectionView.deleteItems(at: selectedCells)
               // collectionView.reloadData()
               // collectionView.deleteItems
             
                deleteButton.isEnabled = false
              }
        }
        
        override func viewWillAppear(_ animated:Bool){
            super.viewWillAppear(animated)
            
             databaseController?.addListener(listener: self)
//            do {
//                let imageDataList = try
//                    managedObjectContext!.fetch(ImageData.fetchRequest())
//                    as [ImageData]
//
//
//                if(imageDataList.count > 0) {
//                    for data in imageDataList {
//                         let fileName = data.fileName!
//                        if(imagePathList.contains(fileName)) {
//                            print("Image already loaded in. Skipping image")
//                            //collectionView.reloadData()
//                            continue
//                        }
//                        if let image = loadImageData(fileName: fileName) {
//                            self.imageList.append(image)
//                            self.imagePathList.append(fileName)
//                            //self.collectionView!.reloadSections([0])
//                            collectionView.reloadData()
//                        }
//                    }
//                }
//            }catch{
//                print("Unable to fetch list of parties")
//            }
                    
            collectionView.reloadData()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
                       super.viewWillDisappear(animated)
                       databaseController?.removeListener(listener: self)
                 
                
                   }
        
        
        
//        func loadImageData(fileName: String) -> UIImage? {
//            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
//            let url = NSURL(fileURLWithPath: path)
//            var image: UIImage?
//            if let pathComponent = url.appendingPathComponent(fileName) {
//                let filePath = pathComponent.path
//                let fileManager = FileManager.default
//                let fileData = fileManager.contents(atPath: filePath)
//                image = UIImage(data: fileData!)
//            }
//            return image
//        }
        
//        func deleteCoreData(imageName : String)
//        {
//
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageData")
//            fetchRequest.predicate = NSPredicate(format: "fileName = %@", imageName)
//
//            do
//            {
//                let test = try managedObjectContext!.fetch(fetchRequest)
//                let objectToDelete = test[0] as! NSManagedObject
//                managedObjectContext!.delete(objectToDelete)
//
//                do {
//                    try managedObjectContext!.save()
//                }
//                catch
//                {
//                    print(error)
//                }
//            }
//            catch
//            {
//                print(error)
//            }
//        }
        
        
        

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

    }

    extension GalleryCollectionVC : PinterestLayoutDelegate {
        func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
            guard let image = UIImage(data: observes[indexPath.item].image!) else {return 0}
            let height = image.size.height / 5
            var res: CGFloat = 0.0
            res = height
            if res > 220 {res = 220}
            else if res < 80 { res = 80}
             res = res + CGFloat(Int.random(in: 0...6))*10
            return res
        }
        
    }

    extension GalleryCollectionVC : UICollectionViewDataSource, UICollectionViewDelegate {
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return observes.count
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionPhotoCell", for: indexPath) as! CollectionPhotoCell
            let image = UIImage(data: observes[indexPath.item].image!)
            cell.imageView.image = image
            cell.nameLabel.text = observes[indexPath.item].name
            
            
            cell.isInEditingMode = isEditing
            return cell
        }
        
        override func setEditing(_ editing: Bool, animated: Bool) {
            super.setEditing(editing, animated: animated)

            collectionView.allowsMultipleSelection = editing
            let indexPaths = collectionView.indexPathsForVisibleItems
            for indexPath in indexPaths {
                let cell = collectionView.cellForItem(at: indexPath) as! CollectionPhotoCell
                cell.isInEditingMode = editing
            }
            deleteButton.isEnabled = true  //modified
        }
        
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //    let cell = collectionView.cellForItem(at: indexPath)
    //    cell?.layer.borderWidth = 2.0
    //    cell?.layer.borderColor = UIColor.gray.cgColor
        
             if !isEditing {
                 deleteButton.isEnabled = false
                 print("noedit")
               // let image = UIImage(data: observes[indexPath.item].image!)
//                let imagePop = storyboard?.instantiateViewController(withIdentifier: "imagePop") as! imagePopViewController
               // imagePop.selectedImage = image
               // present(imagePop, animated: true)
                collectionView.deselectItem(at: indexPath, animated: true)
                let observeDetail = storyboard?.instantiateViewController(withIdentifier: "observeDetailView") as! ObserveDetailVC
                observeDetail.selectObserve = observes[indexPath.item]
               present(observeDetail,animated: true)
             } else {
                 deleteButton.isEnabled = true
                print("edit")
             }
         }

         // 2
          func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
             if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
                 deleteButton.isEnabled = false
             } //else { deleteButton.isEnabled = true }   //
             
         }
        

}
