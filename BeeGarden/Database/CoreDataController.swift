//
//  CoreDataController.swift
//  BeeGarden
//
//  Created by steven liu on 4/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate { 
   
    
   
    
    let DEFAULT_BEE_NAME = "Unnamed Bee"
    var listeners = MulticastDelegate<DatabaseListener>()
    
    var persistantContainer: NSPersistentContainer
    
    // Results
    var allObservesFetchedResultsController: NSFetchedResultsController<ObserveEntity>?
    var allPlantingsFetchedResultsController: NSFetchedResultsController<PlantRecordEntity>?
    var allFlowersFetchedResultsController: NSFetchedResultsController<FlowerEntity>?
    var allBeesFetchedResultsController: NSFetchedResultsController<BeeEntity>?
    var allKnowsFetchedResultsController: NSFetchedResultsController<KnowledgeEntity>?
  var allSpotsFetchedResultsController: NSFetchedResultsController<SpotEntity>?
    //var teamHeroesFetchedResultsController: NSFetchedResultsController<SuperHero>?
    override init() {
        persistantContainer = NSPersistentContainer(name: "Model")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        super.init()
        
        // If there are no heroes in the database assume that the app is running
        // for the first time. Create the default team and initial superheroes.
        if fetchAllBeeObserve().count == 0 {
            createDefaultObserves()
        }
        
        if fetchAllBee().count == 0 {
            createDefaultBees()
        }
        
        if fetchAllKnow().count == 0{
            createDefaultKnows()
        }
        if fetchAllSpot().count == 0{
                   createDefaultSpots()
               }
    }
    
    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    func addObserve(name: String, desc: String, image: UIImage, lat: Double , lon: Double,weather:String, time: Date) -> ObserveEntity {
        let observe = NSEntityDescription.insertNewObject(forEntityName: "ObserveEntity", into:
            persistantContainer.viewContext) as! ObserveEntity
        observe.name = name
        observe.desc = desc
        observe.image = image.jpegData(compressionQuality: 1.0)
        observe.latitude = lat
        observe.longitude = lon
        observe.weather = weather
        observe.time = time
        // This less efficient than batching changes and saving once at end.
        saveContext()
        return observe
    }
    
    
    func deleteObserve(observe: ObserveEntity) {
        persistantContainer.viewContext.delete(observe)
        // This less efficient than batching changes and saving once at end.
        saveContext()
    }
    
    func addBee(name: String, desc: String, image: UIImage) -> BeeEntity {
        let bee = NSEntityDescription.insertNewObject(forEntityName: "BeeEntity", into: persistantContainer.viewContext) as! BeeEntity
        bee.name = name
        bee.desc = desc
        bee.image = image.jpegData(compressionQuality: 1.0)
        saveContext()
        return bee
    }
    
    func deleteBee(bee: BeeEntity) {
        persistantContainer.viewContext.delete(bee)
        saveContext()
    }
    
    func addKnow(name: String, desc: String, time: Date, image: UIImage) -> KnowledgeEntity {
        let know = NSEntityDescription.insertNewObject(forEntityName: "KnowledgeEntity", into: persistantContainer.viewContext) as! KnowledgeEntity
        know.name = name
        know.desc = desc
        know.time = time
        know.image = image.jpegData(compressionQuality: 1.0)
        saveContext()
        return know
    }
    
    func deleteKnow(know: KnowledgeEntity) {
        persistantContainer.viewContext.delete(know)
        saveContext()
    }
    
    func addSpot(name:String,desc:String,openhour:String,place:String,category:Int,latitude:Double,longitude:Double,email:String,website:String,image: UIImage) -> SpotEntity {
        let spot = NSEntityDescription.insertNewObject(forEntityName: "SpotEntity", into: persistantContainer.viewContext) as! SpotEntity
        spot.name = name
        spot.desc = desc
        spot.openhour = openhour
        spot.image = image.jpegData(compressionQuality: 1.0)
        spot.email = email
        spot.latitude = latitude
        spot.longitude = longitude
        spot.website = website
        spot.category = Int16(category)
        spot.place = place
        saveContext()
        return spot
    }
    func deleteSpot(spot: SpotEntity) {
        persistantContainer.viewContext.delete(spot)
        saveContext()
    }
    
    
   
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.observe  {
            listener.onObserveListChange(change: .update, observesDB: fetchAllBeeObserve())
        }
        
        if listener.listenerType == ListenerType.bee  {
             listener.onBeeListChange(change: .update, beesDB: fetchAllBee())
        }
        
        if listener.listenerType == ListenerType.knowledge  {
            listener.onKnowledgeListChange(change: .update, knowsDB: fetchAllKnow())
        }
        
        if listener.listenerType == ListenerType.spot  {
                   listener.onSpotListChange(change: .update, spotsDB: fetchAllSpot())
               }
        
    }
    
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    func fetchAllBeeObserve() -> [ObserveEntity] {
        if allObservesFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<ObserveEntity> = ObserveEntity.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "time", ascending: false)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allObservesFetchedResultsController = NSFetchedResultsController<ObserveEntity>(fetchRequest:
                fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                              cacheName: nil)
            allObservesFetchedResultsController?.delegate = self
            do {
                try allObservesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        
        var observes = [ObserveEntity]()
        if allObservesFetchedResultsController?.fetchedObjects != nil {
            observes = (allObservesFetchedResultsController?.fetchedObjects)!
        }
        
        return observes
    }
    
    func fetchAllBee() -> [BeeEntity] {
          if allBeesFetchedResultsController == nil {
              let fetchRequest: NSFetchRequest<BeeEntity> = BeeEntity.fetchRequest()
              let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
              fetchRequest.sortDescriptors = [nameSortDescriptor]
              allBeesFetchedResultsController = NSFetchedResultsController<BeeEntity>(fetchRequest:
                  fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                                cacheName: nil)
              allBeesFetchedResultsController?.delegate = self
              do {
                  try allBeesFetchedResultsController?.performFetch()
              } catch {
                  print("Fetch bees Request failed: \(error)")
              }
          }
          
          var bees = [BeeEntity]()
          if allBeesFetchedResultsController?.fetchedObjects != nil {
              bees = (allBeesFetchedResultsController?.fetchedObjects)!
          }
          
          return bees
      }
    
    func fetchAllKnow() -> [KnowledgeEntity] {
        if allKnowsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<KnowledgeEntity> = KnowledgeEntity.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "time", ascending: false)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allKnowsFetchedResultsController = NSFetchedResultsController<KnowledgeEntity>(fetchRequest:
                fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                              cacheName: nil)
            allKnowsFetchedResultsController?.delegate = self
            do {
                try allKnowsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch knows Request failed: \(error)")
            }
        }
        
        var knows = [KnowledgeEntity]()
        if allKnowsFetchedResultsController?.fetchedObjects != nil {
            knows = (allKnowsFetchedResultsController?.fetchedObjects)!
        }
        
        return knows
    }
    
    func fetchAllSpot() -> [SpotEntity] {
          if allSpotsFetchedResultsController == nil {
              let fetchRequest: NSFetchRequest<SpotEntity> = SpotEntity.fetchRequest()
              let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
              fetchRequest.sortDescriptors = [nameSortDescriptor]
              allSpotsFetchedResultsController = NSFetchedResultsController<SpotEntity>(fetchRequest:
                  fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                                cacheName: nil)
              allSpotsFetchedResultsController?.delegate = self
              do {
                  try allSpotsFetchedResultsController?.performFetch()
              } catch {
                  print("Fetch knows Request failed: \(error)")
              }
          }
          
          var spots = [SpotEntity]()
          if allSpotsFetchedResultsController?.fetchedObjects != nil {
              spots = (allSpotsFetchedResultsController?.fetchedObjects)!
          }
          
          return spots
      }
    
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allObservesFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.observe  {
                    listener.onObserveListChange(change: .update, observesDB: fetchAllBeeObserve())
                }
            }
        }
        
        if controller == allBeesFetchedResultsController {
            listeners.invoke{ (listener) in
                if listener.listenerType == ListenerType.bee  {
                    listener.onBeeListChange(change: .update, beesDB: fetchAllBee())
                }
            }
        }
        
        if controller == allKnowsFetchedResultsController {
                   listeners.invoke{ (listener) in
                       if listener.listenerType == ListenerType.knowledge  {
                           listener.onKnowledgeListChange(change: .update, knowsDB: fetchAllKnow())
                       }
                   }
               }
        
        if controller == allSpotsFetchedResultsController {
                          listeners.invoke{ (listener) in
                              if listener.listenerType == ListenerType.spot  {
                                  listener.onSpotListChange(change: .update, spotsDB: fetchAllSpot())
                              }
                          }
                      }
        
    }
    
  // var defaultList: SightEntity
    
    func createDefaultObserves() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let someDateTime = formatter.date(from: "2019-10-08 22:31:00")!
        //let _ = addSuperHero(name: "Bruce Wayne", abilities: "Is Rich")
        let _ = addObserve(name: "Honey Bee", desc: "keeped by farmer", image: #imageLiteral(resourceName: "bee2"), lat: -37.1, lon: 144.5, weather: "sunny", time: someDateTime)
        
    }
    
    func createDefaultBees(){
        let _ = addBee(name: "Carpenter", desc: "The 15-24 mm Great Carpenter Bees are the largest bees in Australia! They cut nest burrows in soft timber such as dead limbs of a mango tree.", image: #imageLiteral(resourceName: "Great Carpenter Bee"))
        
        let _ = addBee(name: "Metallic Green Carpenter Bee", desc: "Metallic Green Carpenter Bees, up to 17 mm long, are eyecatching and make a loud buzz as they fly. They love to visit native pea flowers such as Gompholobium.", image: #imageLiteral(resourceName: "Metallic Green Carpenter Bee"))
        
        let _ = addBee(name: "Reed Bee", desc:  "tiny, elongated Reed Bees, up to 8 mm long, are Australia's least known social bees! They escavate tiny nest burrows inside pithy stems of plants such as grass trees or tree ferns. Two or more adult bees may share a nest and co-operate to share the nest duties.", image: #imageLiteral(resourceName: "Reed Bee"))
    }
    
    func createDefaultKnows(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let someDateTime = formatter.date(from: "2019-10-08 22:31:00")!
        let someDateTime2 = formatter.date(from: "2019-11-08 22:31:00")!
        
        let _  = addKnow(name: "How do native bees get along with commercial bees?", desc: "If commercial Honey Bees (Apis mellifera) and native bees are foraging on the same flowers, they do not fight one another. However, commercial Honey Bees are much better foragers than most native bee species and they can often fly at much lower temperatures. If there is plenty of food available, this would probably not cause a problem. However, in a situation of limited food resources, the native bees would probably come out second best. Most of our native bees are tiny, fragile, almost inconspicuous creatures and such bees would have great difficulty competing with the highly efficient commercial bees we have introduced from Europe.", time: someDateTime, image: #imageLiteral(resourceName: "beeknow1"))
        
        let _ = addKnow(name: "How many types of native bees are there in Australia?", desc: "Australia has over 1,700 species of native bees. They come in a startling array of colours and range from 2 to 26 mm in size. Some have thick furry overcoats, while others are smooth and shiny like a highly-polished car. The vast majority of Australia's native bees are solitary but Australia also has eleven species of social Stingless Native Bees", time: someDateTime2, image: #imageLiteral(resourceName: "beeknow2"))
    }
    
    func createDefaultSpots() {
        
        let _ = addSpot(name: "Victorian Apiarists' Association", desc: "The Victorian Apiarists’ Association can help all beekeepers regardless of how many bee hives they own.  Whether you are a hobbyist beekeeper with one hive in the backyard, a semi-commercial beekeeper wishing to take the next step towards becoming entirely financially dependent on beekeeping or the full-time commercial beekeeper.", openhour: "from 7:30 pm on the last Thursday of each month except December ", place: "Church of Christ Hall, corner Cherry Rd and Whitehorse Rd, Balwyn", category: 1, latitude: -37.81239495, longitude: 145.0775918, email: "03 9317 7142", website: "https://www.vicbeekeepers.com.au/", image: #imageLiteral(resourceName: "vaa"))
        
    }
}
