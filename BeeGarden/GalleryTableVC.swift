//
//  GalleryTableVC.swift
//  BeeGarden
//
//  Created by steven liu on 5/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CoreData

protocol FocusObserveDelegate {
    func foucusObserve(observe: ObserveEntity)
}

class GalleryTableVC: UITableViewController,UISearchResultsUpdating, DatabaseListener  {
    func onGardenChange(change: DatabaseChange, gardenPlants: [FlowerEntity]) {
        
    }
    
    func onFlowerListChange(change: DatabaseChange, flowersDB: [FlowerEntity]) {
        
    }
    
    func onRecordListChange(change: DatabaseChange, recordsDB: [PlantRecordEntity]) {
        
    }
    
    func onSpotListChange(change: DatabaseChange, spotsDB: [SpotEntity]) {
        
    }
    
    func onKnowledgeListChange(change: DatabaseChange, knowsDB: [KnowledgeEntity]) {
        
    }
    
    func onBeeListChange(change: DatabaseChange, beesDB: [BeeEntity]) {
    
    }
    
    

    var focusObserveDelegate : FocusObserveDelegate?
    let SECTION_OBSERVE = 0
    let SECTION_COUNT = 1
    let CELL_OBSERVE = "observeCell"
    let CELL_COUNT = "observeSizeCell"
    
      let searchController = UISearchController(searchResultsController: nil)
    
    var observes : [ObserveEntity] = []  //Observe
    var filteredObserves: [ObserveEntity] = []
    
    weak var addObserveDelegate: AddObserveDelegate?
    weak var databaseController : DatabaseProtocol?  //coredata
    
    var listenerType = ListenerType.observe
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController   //coredata
        
        filteredObserves = observes
      
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Observations"
        navigationItem.searchController = searchController
       
        
        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
        
        searchController.isActive = false
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           databaseController?.removeListener(listener: self)
           
       }
    
    
    
    func onObserveListChange(change: DatabaseChange, observesDB : [ObserveEntity]) {
        observes = observesDB
        updateSearchResults(for: navigationItem.searchController!)
        
    }
    
     func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count > 0 {  //lowercased()
            filteredObserves = observes.filter({(observe: ObserveEntity) -> Bool in
                return observe.name!.contains(searchText)  //lowercased()
            })
        }
        else {
           
            filteredObserves = observes;
        }
        tableView.reloadData();
        
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == SECTION_OBSERVE {
            return filteredObserves.count
        } else {
            return 1
        }
    }
  

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_OBSERVE {
        let observeCell = tableView.dequeueReusableCell(withIdentifier: CELL_OBSERVE, for: indexPath) as!
        GalleryTableViewCell
        let observe = filteredObserves[indexPath.row]
        observeCell.observeName.text = observe.name
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            observeCell.observeTime.text = df.string(from: observe.time! )
            observeCell.observeImage.image = UIImage(data: observe.image! as Data)
        return observeCell
       }
        
        let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
            countCell.textLabel?.text = "\(observes.count) observations in the database"
            countCell.selectionStyle = .none
            return countCell
            
        }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if indexPath.section == SECTION_COUNT {
              tableView.deselectRow(at: indexPath, animated: true)
          }
          if indexPath.section == SECTION_OBSERVE {
              let observe = filteredObserves[indexPath.row]
              focusObserveDelegate?.foucusObserve(observe: observe)
              print("row \(indexPath.row) selected")
              tableView.deselectRow(at: indexPath, animated: true)
             // navigationController?.popViewController(animated: true)
          }
          
          
          }
    
    func displayMessage(title: String, message: String) {
           // Setup an alert to show user details about the Person
           // UIAlertController manages an alert instance
           let alertController = UIAlertController(title: title, message: message, preferredStyle:
               UIAlertController.Style.alert)
           alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler:
               nil))
           self.present(alertController, animated: true, completion: nil)
       }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_OBSERVE {
            return true
        }
        return false
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // Delete the row from the data source
               if editingStyle == .delete && indexPath.section == SECTION_OBSERVE {
                   databaseController?.deleteObserve(observe: filteredObserves[indexPath.row])
               }
             
           } else if editingStyle == .insert {
               // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
           }
       }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_OBSERVE {
            return 103.0;//Choose your custom row height
        }
        else { return 44.0}
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
