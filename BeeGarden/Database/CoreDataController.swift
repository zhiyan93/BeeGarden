//
//  CoreDataController.swift
//  BeeGarden
//
//  Created by steven liu on 4/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate  {
   
    
       
    
    let DEFAULT_GARDEN = "my garden"
    var listeners = MulticastDelegate<DatabaseListener>()
    
    var persistantContainer: NSPersistentContainer
    
    // Results
    var allObservesFetchedResultsController: NSFetchedResultsController<ObserveEntity>?
    var allRecordsFetchedResultsController: NSFetchedResultsController<PlantRecordEntity>?
    var allFlowersFetchedResultsController: NSFetchedResultsController<FlowerEntity>?
    var allBeesFetchedResultsController: NSFetchedResultsController<BeeEntity>?
    var allKnowsFetchedResultsController: NSFetchedResultsController<KnowledgeEntity>?
  var allSpotsFetchedResultsController: NSFetchedResultsController<SpotEntity>?
    
    var gardenPlantsFetchedResultsController : NSFetchedResultsController<FlowerEntity>?
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
        if fetchAllFlower().count == 0{
            createDefaultFlowers()
        }
        if fetchAllRecord().count == 0{
            createDefaultRecords()
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
    
    func addFlower(name: String, desc: String, image: UIImage, gmonth: String, gclimate: String, pollen: String, nectar: String, category: String) -> FlowerEntity {
        let flower = NSEntityDescription.insertNewObject(forEntityName: "FlowerEntity", into: persistantContainer.viewContext) as! FlowerEntity
        flower.name = name
        flower.desc = desc
        flower.image = image.jpegData(compressionQuality: 1.0)
        flower.gmonth = gmonth
        flower.gclimate = gclimate
        flower.pollen = pollen
        flower.nectar = nectar
        flower.category = category
        saveContext()
        return flower
        
    }
    
    func deleteFlower(flower: FlowerEntity) {
        persistantContainer.viewContext.delete(flower)
        saveContext()
    }
    
    func addRecord(name: String, type: String, time: Date, counting: Int) -> PlantRecordEntity {
         let record = NSEntityDescription.insertNewObject(forEntityName: "PlantRecordEntity", into: persistantContainer.viewContext) as! PlantRecordEntity
        record.name = name
        record.type = type
        record.time = time 
        record.counting = Int16(counting)
        saveContext()
        return record
        
    }
    
    func deleteRecord(record: PlantRecordEntity) {
        persistantContainer.viewContext.delete(record)
        saveContext()
    }
    
   //
    
    func addGarden(gardenName: String) -> GardenEntity {
           let garden = NSEntityDescription.insertNewObject(forEntityName: "GardenEntity", into: persistantContainer.viewContext) as! GardenEntity
        
        garden.name = gardenName
        saveContext()
        return garden
       }
       
       
       func addPlantToGarden(plant: FlowerEntity, garden: GardenEntity) -> Bool {
           guard let plantlist = garden.plants, plantlist.contains(plant) == false else {
           return false }
        garden.addToPlants(plant)
        saveContext()
        return true
       }
       
       func removePlantFromGarden(plant: FlowerEntity, garden: GardenEntity) {
        garden.removeFromPlants(plant)
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
        
        if listener.listenerType == ListenerType.flower  {
            listener.onFlowerListChange(change: .update, flowersDB: fetchAllFlower())
        }
        
        if listener.listenerType == ListenerType.plantRecord  {
            listener.onRecordListChange(change: .update, recordsDB: fetchAllRecord())
        }
        
        if listener.listenerType == ListenerType.garden  {
            listener.onGardenChange(change: .update, gardenPlants: fetchGardenPlants())
            listener.onFlowerListChange(change: .update, flowersDB: fetchAllFlower())
               }
        
        
        //
        
        if listener.listenerType == ListenerType.all {
            listener.onObserveListChange(change: .update, observesDB: fetchAllBeeObserve())
            listener.onSpotListChange(change: .update, spotsDB: fetchAllSpot())
            listener.onFlowerListChange(change: .update, flowersDB: fetchAllFlower())
            listener.onGardenChange(change: .update, gardenPlants: fetchGardenPlants())
            
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
                  print("Fetch spots Request failed: \(error)")
              }
          }
          
          var spots = [SpotEntity]()
          if allSpotsFetchedResultsController?.fetchedObjects != nil {
              spots = (allSpotsFetchedResultsController?.fetchedObjects)!
          }
          
          return spots
      }
    
    func fetchAllFlower() -> [FlowerEntity] {
             if allFlowersFetchedResultsController == nil {
                 let fetchRequest: NSFetchRequest<FlowerEntity> = FlowerEntity.fetchRequest()
                 let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                 fetchRequest.sortDescriptors = [nameSortDescriptor]
                 allFlowersFetchedResultsController = NSFetchedResultsController<FlowerEntity>(fetchRequest:
                     fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                                   cacheName: nil)
                 allFlowersFetchedResultsController?.delegate = self
                 do {
                     try allFlowersFetchedResultsController?.performFetch()
                 } catch {
                     print("Fetch flowers Request failed: \(error)")
                 }
             }
             
             var flowers = [FlowerEntity]()
             if allFlowersFetchedResultsController?.fetchedObjects != nil {
                 flowers = (allFlowersFetchedResultsController?.fetchedObjects)!
             }
             
             return flowers
         }
    
    func fetchAllRecord() -> [PlantRecordEntity] {
             if allRecordsFetchedResultsController == nil {
                 let fetchRequest: NSFetchRequest<PlantRecordEntity> = PlantRecordEntity.fetchRequest()
                 let nameSortDescriptor = NSSortDescriptor(key: "time", ascending: false)
                 fetchRequest.sortDescriptors = [nameSortDescriptor]
                 allRecordsFetchedResultsController = NSFetchedResultsController<PlantRecordEntity>(fetchRequest:
                     fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                                   cacheName: nil)
                 allRecordsFetchedResultsController?.delegate = self
                 do {
                     try allRecordsFetchedResultsController?.performFetch()
                 } catch {
                     print("Fetch gardening records Request failed: \(error)")
                 }
             }
             
             var records = [PlantRecordEntity]()
             if allRecordsFetchedResultsController?.fetchedObjects != nil {
                 records = (allRecordsFetchedResultsController?.fetchedObjects)!
             }
             
             return records
         }
    
    func fetchGardenPlants() -> [FlowerEntity] { 
if gardenPlantsFetchedResultsController == nil {
let fetchRequest: NSFetchRequest<FlowerEntity> = FlowerEntity.fetchRequest()
let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
fetchRequest.sortDescriptors = [nameSortDescriptor]
let predicate = NSPredicate(format: "ANY gardens.name == %@", DEFAULT_GARDEN)
fetchRequest.predicate = predicate
  gardenPlantsFetchedResultsController = NSFetchedResultsController<FlowerEntity>(fetchRequest: fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
gardenPlantsFetchedResultsController?.delegate = self
do {
try gardenPlantsFetchedResultsController?.performFetch()
} catch {
print("Fetch Request failed: \(error)")
}
}
var plants = [FlowerEntity]()
if gardenPlantsFetchedResultsController?.fetchedObjects != nil {
plants = (gardenPlantsFetchedResultsController?.fetchedObjects)!
}
return plants
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
        
        if controller == allFlowersFetchedResultsController {
                                 listeners.invoke{ (listener) in
                                     if listener.listenerType == ListenerType.flower  {
                                         listener.onFlowerListChange(change: .update, flowersDB: fetchAllFlower())
                                     }
                                 }
                             }
        if controller == allRecordsFetchedResultsController {
                                 listeners.invoke{ (listener) in
                                     if listener.listenerType == ListenerType.plantRecord  {
                                         listener.onRecordListChange(change: .update, recordsDB: fetchAllRecord())
                                     }
                                 }
                             }
        
        if controller == gardenPlantsFetchedResultsController {
            listeners.invoke{ (listener) in
                if listener.listenerType == ListenerType.garden {
                    listener.onGardenChange(change: .update, gardenPlants: fetchGardenPlants())
                }
        }
        
    }
    }
        
        
lazy var defaultGarden: GardenEntity = {
var gardens = [GardenEntity]()
let request: NSFetchRequest<GardenEntity> = GardenEntity.fetchRequest()
let predicate = NSPredicate(format: "name = %@", DEFAULT_GARDEN)
request.predicate = predicate
do {
try gardens = persistantContainer.viewContext.fetch(GardenEntity.fetchRequest()) as! [GardenEntity]
} catch {
print("Fetch Request failed: \(error)")
}
if gardens.count == 0 {
return addGarden(gardenName: DEFAULT_GARDEN)
}
else {
return gardens.first!
}
}()
    
    
    
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
        
         let _ = addSpot(name: "Melbourne Museum", desc: "Melbourne museum is a rich response to Melbourne's urban condition, and provides a place for education, history, culture and society to engage with each other in a contemporary setting.[2] It is now an important part of Melbourne's soft infrastructure and is consistently ranked as one of the most popular museums and tourist attractions in Australia, winning 'Best Tourist Attraction' at the Australian Tourism Awards in 2011", openhour: "from 7:30 pm on the last Thursday of each month except December ", place: "Church of Christ Hall, corner Cherry Rd and Whitehorse Rd, Balwyn", category: 2, latitude: -37.8033, longitude: 144.9717, email: "(03) 8341 7767", website: "https://museumsvictoria.com.au/melbournemuseum", image: #imageLiteral(resourceName: "melbmuseum"))
        
         let _ = addSpot(name: "Pure Peninsula Honey", desc: "Over the course of 25 years, Pure Peninsula Honey has worked assiduously to develop products to suit everybody's needs, tastes and desires. Today, there are close to 30 different honey, wax, honeycomb and cosmetic products that you can purchase. With passion as a foundation, orchards in many parts of Victoria and New South Wales are regularly pollinated and honey is produced with a vast depth knowledge and experience.", openhour: "9am - 5pm, 7 days a week", place: "871 Derril Rd, Moorooduc,VIC 3933, Melbourne", category: 3, latitude: -38.23969, longitude: 145.10673, email: "(03) 5978 8413", website: "https://www.purepeninsulahoney.com.au/", image: #imageLiteral(resourceName: "purepen"))
        
        let _ = addSpot(name: "The Greenery Garden Centre", desc: "The Greenery Garden Centre has been operating on a gentle bend of the Yarra  river for over 42 years in Heidelberg by the same owner.  You will find all your gardening needs are catered for, from our ever growing outdoor furniture range, homewares, plants and our expansive Outdoor Living department featuring water features, pots and planters, indoor and outdoor garden art and cast iron urns and fountains!", openhour: "Weekdays: 7:30 am - 4:30pm; Weekends: 8:30 am - 4:00pm", place: "4 Banksia St, Heidelberg, VIC 3084", category: 4, latitude: -37.76016, longitude: 145.07397, email: "03 9459 8433", website: "http://www.thegreenery.com.au/", image:#imageLiteral(resourceName: "greenery"))
        
    }
    
    func createDefaultFlowers(){
        let _ = addFlower(name: "Lavender", desc: "Lavender-It is grown in cool-climate zones and mainly known for its fragrance. These lasting herbs attract the bees greatly and they grow in a widespread format. It is well known to stand still in droughts, requires complete sun to grow properly and does not like shade. Also, the soil should be sandy to rough and should be well drained. These can be planted in a pot, container or ground. Lavenders attract honeybees, blue banded native bees, bumble bees and solitary bees.", image: #imageLiteral(resourceName: "lavender"), gmonth: "12,1,2", gclimate: "Cool", pollen: "high", nectar: "high", category: "herb")
    }
    
    func createDefaultRecords(){
        let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               let someDateTime = formatter.date(from: "2020-01-01 22:31:00")!
        let _ = addRecord(name: "watering1", type: "watering", time: someDateTime, counting: 2)
    }
}
