//
//  HomeTabVC.swift
//  BeeGarden
//
//  Created by steven liu on 9/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CoreData


class HomeTabVC: UIViewController, DatabaseListener {
    func onFlowerListChange(change: DatabaseChange, flowersDB: [FlowerEntity]) {
        
    }
    
    func onRecordListChange(change: DatabaseChange, recordsDB: [PlantRecordEntity]) {
        
    }
    
    func onSpotListChange(change: DatabaseChange, spotsDB: [SpotEntity]) {
        
    }
    
    func onKnowledgeListChange(change: DatabaseChange, knowsDB: [KnowledgeEntity]) {
    
    }
    
    
    
    
    var listenerType = ListenerType.bee
    var bees : [BeeEntity] = []
    weak var databaseController : DatabaseProtocol?  //coredata
    
    func onObserveListChange(change: DatabaseChange, observesDB: [ObserveEntity]) {
    
    }
    
    func onBeeListChange(change: DatabaseChange, beesDB: [BeeEntity]) {
        bees = beesDB
    
    }
    
    
    // MARK: - Constants
    
    let cellWidth = (0.7) * UIScreen.main.bounds.width
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
        layout.itemSize = CGSize(width: cellWidth * 0.9, height: cellWidth * 0.65)
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
              databaseController = appDelegate.databaseController   //coredata
        // Do any additional setup after loading the view.
       
        design()
        registerCollectionViewCells()
        applyConstraints()
        
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          databaseController?.addListener(listener: self)
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
            view.backgroundColor = .white
    
        }
        
        private func registerCollectionViewCells() {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        }
        
        private func applyConstraints() {
            view.addSubview(collectionView)
            collectionView.centerXAnchor .constraint(equalTo: view.centerXAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            collectionView.heightAnchor.constraint(equalToConstant: cellWidth * 0.7 ).isActive = true
        }
    }

    // MARK: - CollectionView Data Source

    extension HomeTabVC: UICollectionViewDataSource, UICollectionViewDelegate {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return bees.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
         //  let color = colors[indexPath.item]
          //  let imageView = UIImageView()
            
          //  imageView.image = UIImage(named:"bee2")
          //  imageView.contentMode = UIView.ContentMode.scaleAspectFit
          //  cell.backgroundColor = color
           // cell.contentView.addSubview(imageView)
            
          //  let imageview:UIImageView=UIImageView(frame: CGRect(x: -40, y: 20, width: cellWidth, height: 300));
        //    imageview.layer.cornerRadius = 10 // change this number to get the corners you want
          //    imageview.layer.masksToBounds = true
          //  imageview.contentMode = UIView.ContentMode.scaleAspectFit
//            let imageLabel: UILabel = UILabel(frame: CGRect(x: -10, y:cellWidth * 0.65 ,width:cellWidth - 50, height: 20))//
            let bee = bees[indexPath.item]
//            imageLabel.text = bee.name
//            imageLabel.textAlignment = .center
            let img : UIImage = UIImage(data: bee.image! as Data)!
        
        //    imageview.image = img
            
        let myImageView:UIImageView = UIImageView()
            myImageView.frame.size.width = cellWidth * 0.95
            myImageView.frame.size.height = cellWidth * 0.65
          //  myImageView.frame.offsetBy(dx: -40, dy: 20)
            myImageView.frame = myImageView.frame.offsetBy(dx: 0, dy: 0)
          //  myImageView.center = self.view.center
            myImageView.image = img
             myImageView.layer.cornerRadius = 20 // change this number to get the corners you want
             myImageView.layer.masksToBounds = true
            
            cell.contentView.addSubview(myImageView)
            
          //  cell.contentView.addSubview(imageLabel)
            return cell
        }
        
    
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            print("item \(indexPath.item) selected")
          let beeDetail = storyboard?.instantiateViewController(withIdentifier: "beeDetail") as! HomeBeeDetailVC
            beeDetail.selectedBee = bees[indexPath.item]
    
            present(beeDetail, animated: true)
            
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
      
        
        
       
    }




