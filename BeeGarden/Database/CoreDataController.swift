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
   
    
       
    //default garden name
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
    
    //apply database change
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
        let _ = addObserve(name: "Honey Bee", desc: "Bee in my garden", image: #imageLiteral(resourceName: "bee2"), lat: -37.1, lon: 144.5, weather: "Sunny", time: someDateTime)
        
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
        
        let _ = addSpot(name: "Victorian Apiarists' Association", desc: "The Victorian Apiarists’ Association can help all beekeepers regardless of how many bee hives they own.  Whether you are a hobbyist beekeeper with one hive in the backyard, a semi-commercial beekeeper wishing to take the next step towards becoming entirely financially dependent on beekeeping or the full-time commercial beekeeper.", openhour: "from 7:30 pm on the last Thursday of each month except December.", place: "Church of Christ Hall, corner Cherry Rd and Whitehorse Rd, Balwyn", category: 1, latitude: -37.81239495, longitude: 145.0775918, email: "03 9317 7142", website: "https://www.vicbeekeepers.com.au/", image: #imageLiteral(resourceName: "vaa"))
        
         let _ = addSpot(name: "Melbourne Museum", desc: "Melbourne museum is a rich response to Melbourne's urban condition, and provides a place for education, history, culture and society to engage with each other in a contemporary setting. It is now an important part of Melbourne's soft infrastructure and is consistently ranked as one of the most popular museums and tourist attractions in Australia, winning 'Best Tourist Attraction' at the Australian Tourism Awards in 2011.", openhour: "from 7:30 pm on the last Thursday of each month except December.", place: "Church of Christ Hall, corner Cherry Rd and Whitehorse Rd, Balwyn.", category: 2, latitude: -37.8033, longitude: 144.9717, email: "(03) 8341 7767", website: "https://museumsvictoria.com.au/melbournemuseum", image: #imageLiteral(resourceName: "melbmuseum"))
        
         let _ = addSpot(name: "Pure Peninsula Honey", desc: "Over the course of 25 years, Pure Peninsula Honey has worked assiduously to develop products to suit everybody's needs, tastes and desires. Today, there are close to 30 different honey, wax, honeycomb and cosmetic products that you can purchase. With passion as a foundation, orchards in many parts of Victoria and New South Wales are regularly pollinated and honey is produced with a vast depth knowledge and experience.", openhour: "9am - 5pm 7 days a week.", place: "871 Derril Rd, Moorooduc,VIC 3933, Melbourne.", category: 3, latitude: -38.23969, longitude: 145.10673, email: "(03) 5978 8413", website: "https://www.purepeninsulahoney.com.au/", image: #imageLiteral(resourceName: "purepen"))
        
        let _ = addSpot(name: "The Greenery Garden Centre", desc: "The Greenery Garden Centre has been operating on a gentle bend of the Yarra  river for over 42 years in Heidelberg by the same owner.  You will find all your gardening needs are catered for, from our ever growing outdoor furniture range, homewares, plants and our expansive Outdoor Living department featuring water features, pots and planters, indoor and outdoor garden art and cast iron urns and fountains.", openhour: "Weekdays: 7:30 am - 4:30pm;Weekends: 8:30 am - 4:00pm.", place: "4 Banksia St, Heidelberg, VIC 3084.", category: 4, latitude: -37.76016, longitude: 145.07397, email: "03 9459 8433", website: "http://www.thegreenery.com.au/", image:UIImage(named:"greenery")!)
        // nursery
        
        let _ = addSpot(name: "TGA Australia", desc: "Specialising in the production of advanced trees, hedges and shrubs. 'Wholesale-only' nursery and supply only to the retail and landscape trades.", openhour: "Monday to Thursday 8am–5pm,Friday 8am–4pm,Saturday Closed,Sunday Closed.", place: "50 Speedwell St, Somerville VIC 3912", category: 4, latitude: -38.217670, longitude: 145.183800, email: "(03) 5977 6044", website: "https://www.tgaaustralia.com.au/", image:UIImage(named:"TGA Australia")!)

        let _ = addSpot(name: "Gardenworld", desc: "Gardenworld is a group of 7 independently owned businesses, each one passionate about gardening and outdoor living. There is only one Gardenworld, so you will find nothing else quite like this anywhere else in Australia.", openhour: "9am–5pm for 7 days a week.", place: "810 Springvale Rd, Braeside VIC 3195.", category: 4, latitude: -38.002770, longitude: 145.141990, email: "(03) 9798 8095", website: "https://gardenworld.com.au/", image:UIImage(named:"Gardenworld")!)

        let _ = addSpot(name: "Emerald Gardens Nursery", desc: "Emerald Gardens Nursery is a family owned plant farm in Emerald in the Dandenong Ranges. They grow a large range of trees and shrubs on their 8 acre property.", openhour: "9:30am–4:30pm for 7 days a week.", place: "77A Emerald-Monbulk Rd, Emerald VIC 3782", category: 4, latitude: -37.915180, longitude: 145.446500, email: "(03) 5968 5745", website: "https://www.emeraldgardensnursery.com.au/", image:UIImage(named:"Emerald Gardens Nursery")!)

        let _ = addSpot(name: "Pinewood Quality Nursery", desc: "Pinewood Nursery established since 1960 is located in Glen Waverley and offers a large off street car park for your convenience. They have a team of qualified staff led by Craig who has been employed at Pinewood Nursery for over 40 years.", openhour: "8:00am–5.00pm for 7 days a week.", place: "478 Blackburn Rd, Glen Waverley VIC 3150.", category: 4, latitude: -37.892578, longitude: 145.144791, email: "(03) 9560 8711", website: "http://pinewoodnursery.com.au/", image:UIImage(named:"Pinewood Quality Nursery")!)

        let _ = addSpot(name: "Acorn Nursery", desc: "Acorn Nursery Is Known And Beloved For Top-quality Plants And Garden Products, Unique Gifts, And Expert Service From The Team Of Qualified Horticulturalists.", openhour: "9:00am–5:00pm on weekdays and weekends.", place: "669-673 Canterbury Rd, Surrey Hills VIC 3127.", category: 4, latitude: -37.825899, longitude: 145.100901, email: "(03) 9890 3162", website: "https://acornnursery.com.au/", image:UIImage(named:"Acorn Nursery")!)

        let _ = addSpot(name: "Victorian Indigenous Nurseries Co-Operative", desc: "Victorian Indigenous Nurseries Co-operative (VINC) propagates and supplies local native (indigenous) plants to local government and government agencies for bushland revegetation.", openhour: "Monday 10.00am–3.00pm,Tuesday 10.00am–3.00pm,Wednesday Closed,Thursday Closed,Friday 10.00am–3.00pm,Saturday Closed,Sunday Closed.", place: "Yarra Bend Rd, Fairfield VIC 3078", category: 4, latitude: -37.791782, longitude: 145.009349, email: "(03) 9482 1710", website: "https://www.vinc.net.au/", image:UIImage(named:"Victorian Indigenous Nurseries Co-Operative")!)

        let _ = addSpot(name: "Bayside Community Plant Nursery", desc: "Indigenous plants can be used to beautiful effect in almost any style of garden. Not only are they sustainable, with lower maintenance requirements than other gardens, but indigenous plants are surprisingly easy to maintain and propagate, are fauna-friendly and generally use less water than other plants.", openhour: "Weekdays 10.00am–3.00pm;Saturday 10.00am-12.00pm,Sunday Closed.", place: "315-317 Reserve Rd, Cheltenham VIC 3192", category: 4, latitude: -37.962471, longitude: 145.037223, email: "(03) 9583 8408", website: "https://www.bayside.vic.au/bayside-community-nursery-reopening-delayed-due-covid-19", image:UIImage(named:"Bayside Community Plant Nursery")!)

        let _ = addSpot(name: "Northcote Nursery", desc: "Old fashioned service and traditional gardening ideals make this experience unique. Every nook and cranny of this little corner lot is filled to capacity with plant life & gardening requirements.", openhour: "Weekdays 10.30am–3.00pm,Saturday 9.00am-5.00pm,Sunday 9.00am-5.00pm.", place: "85 South Cres, Northcote VIC 3070.", category: 4, latitude: -37.778739, longitude: 145.010093, email: "(03) 9482 2997", website: "https://www.northcotenursery.com.au/", image:UIImage(named:"Northcote Nursery")!)

        let _ = addSpot(name: "Bonsai Art Nursery", desc: "Bonsai Art Nursery was established in 1983 and is owned and operated by Trevor McComb and is conveniently located in Heatherton in Melbourne near Moorabbin Airport and is situated on 5 acres (Melways Reference Map 87 K1).", openhour: "Weekdays 10.00am–4.00pm ,Saturday 10.00am–3.00pm,Sunday 10.00am–4.00pm.", place: "236 Old Dandenong Rd, Heatherton VIC 3202", category: 4, latitude: -37.962915, longitude: 145.106700, email: "(03) 9551 0725", website: "http://bonsaiart.com.au/", image:UIImage(named:"Bonsai Art Nursery")!)

        let _ = addSpot(name: "Scotsburn Nurseries Pty Ltd", desc: "Established in 1930, Scotsburn Nurseries supplies Melbourne and Victoria's best independent retail nurseries. They are proud of their long-standing reputation as a producer of quality flowers, vegetables and herbs.", openhour: "Weekdays 8.00am–5.00pm,Saturday Closed,Sunday Closed.", place: "300 Perry Rd, Keysborough VIC 3173", category: 4, latitude: -38.026877, longitude: 145.181108, email: "(03) 9798 7066", website: "http://www.scotsburn.biz/", image:UIImage(named:"Scotsburn Nurseries Pty Ltd")!)

        
        // farms
        let _ = addSpot(name: "Kelvin Trading Pty Ltd", desc: "They specialise as an import organisation and stock all the materials and equipment for an apiarist, further information can be found on the website.", openhour: "Wednesday & Friday 10.00am - 4:00pm.", place: "4/12-14 Miles St, Mulgrave VIC 3170", category: 3, latitude: -37.923120, longitude: 145.150620, email: "0405 123 098", website: "http://www.kelvintrading.com.au/", image:UIImage(named:"Kelvin Trading Pty Ltd")!)

        let _ = addSpot(name: "The Practical Beekeeper", desc: "They are registered beekeepers and also work towards assembling swarms,efficient in managing beehives and have their personalised educational materials, for more information please visit their website.", openhour: "Weekdays 10.00am - 5:00pm,Weekends Closed.", place: "2 Wingrove St, Alphington VIC 3078", category: 3, latitude: -37.777530, longitude: 145.032280, email: "0418 863 884", website: "http://thepracticalbeekeeper.com.au/", image:UIImage(named:"The Practical Beekeeper")!)

//        let _ = addSpot(name: "Archibald honey", desc: "Please visit the website for more information!", openhour: "Tuesday, Wednesday, Thursday : 9.00 am - 3:00pm; Monday, Friday, Saturday, Sunday: Closed", place: "369 Spring Rd, Dingley Village VIC 3172", category: 3, latitude: -37.984890, longitude: 1145.141890, email: "+64 395511860", website: "http://www.archibaldhoney.com.au/", image:UIImage(named:"Archibald honey")!)

        let _ = addSpot(name: "Amazing Bees", desc: "This is a great knowledgeable website to learn about bees and its behaviours, they do not have a bee farm or a honey farm for visits but one can go and learn about bees from their website.", openhour: "Appointment only.", place: "25 Democrat Dr, The Basin VIC 3154", category: 3, latitude: -37.852880, longitude: 145.304170, email: "0414 558 400", website: "https://amazingbees.com.au/", image:UIImage(named:"Amazing Bees")!)

//        let _ = addSpot(name: "Pure Peninsula Honey", desc: "They stock products which suits everybody’s needs and consists of farms, honey products and other services such as pollination and wasp removal,please visit the website for more information!", openhour: "Weekdays & Weekends- 9.00am- 3.00pm", place: " 871 Derril Rd, Moorooduc VIC 3933", category: 3, latitude: -38.239690, longitude: 145.106730, email: "(03) 5978 8413", website: "purepeninsulahoney.com.au", image:UIImage(named:"Pure Peninsula Honey")!)




        let _ = addSpot(name: "Ben's Bees", desc: "A bee farm which applies many service of bees,such as selling bee hive and bee removal, please visit the website for more information.", openhour: "7am to 8pm everyday.", place: "15 Marilyn Ct, Blackburn North VIC 3130", category: 3, latitude: -37.805990, longitude: 145.167810, email: "0437 077 792", website: "https://www.bensbees.com.au/", image:UIImage(named:"Ben_s Bees")!)


        let _ = addSpot(name: "Bee Rescue Melbourne", desc: "Focus on bee hive removal & rescue, and provide raw local honey,please visit the website for more information.", openhour: "7am to 7pm everyday.", place: "30 Gosfidld Rd, Hursbridge,VIC 3099", category: 3, latitude: -37.632520, longitude: 145.213690, email: "0408 336 363", website: "https://beerescue.com.au/", image:UIImage(named:"Bee Rescue Melbourne")!)


        let _ = addSpot(name: "Heathmont Honey", desc: "This bee farm is located in the eastern suburbs of Melbourne. Beekeeping is one of the most ancient craft for them,please visit the website for more information.", openhour: "Weekdays 12pm to 5pm.", place: "30 Washusen Rd, Heathmont VIC 3135", category: 3, latitude: -37.837250, longitude: 145.240350, email: "(03) 9738 0456", website: "http://www.heathmonthoney.com.au/", image:UIImage(named:"Heathmont Honey")!)



        let _ = addSpot(name: "Honey Paradise", desc: "They separate their honeys according to their floral type, allowing the flavours of each individual floral to be exhibited,please visit the website for more information.", openhour: "Wed. Thu. and Fri. 9:30am to 5pm.", place: "45 Huntingdale Rd, Burwood VIC 3125", category: 3, latitude: -37.858720, longitude: 145.113210, email: "(03) 9808 8828", website: "http://honeyparadise.com.au/", image:UIImage(named:"Honey Paradise")!)

        let _ = addSpot(name: "Upper Beaconsfield Certified Organic Apiaries", desc: "They are a family-run boutique bee and organic honey apiary based 50km south east of Melbourne in the foothills of The Dandenongs,please visit the website for more information.", openhour: "Appointment only.", place: "184 Berglund Rd, Beaconsfield Upper VIC 3808", category: 3, latitude: -38.002790, longitude: 145.452810, email: "0448 916 566", website: "https://organichoney.melbourne/", image:UIImage(named:"Upper Beaconsfield Certified Organic Apiaries")!)

        let _ = addSpot(name: "Beekeeping Supplies & Equipment", desc: "They are a small family business supplying and manufacturing beekeeping equipment for hobby beekeepers,please visit the website for more information.", openhour: "Sat 8am to 9am.", place: "410 Andersons Rd, Mount Moriac VIC 3240", category: 3, latitude: -38.203011, longitude: 144.205292, email: "(03) 5266 1086", website: "https://www.meleebeefarm.com/", image:UIImage(named:"Beekeeping Supplies & Equipment")!)


        let _ = addSpot(name: "Aussie Apiaries", desc: "Here at Aussie Apiaries we pride ourselves on producing everything in-house,please visit the website for more information.", openhour: "Mon. 9am to 3pm,Wed. 9am to 3pm,Fri. and Sat. 9am to 3pm.", place: "11 Carrick Dr, Tullamarine VIC 3043", category: 3, latitude: -37.701958, longitude: 144.883362, email: "0408 557 719", website: "http://aussieapiaries.com.au/", image:UIImage(named:"Aussie Apiaries")!)
        
        
// clubs
        
        let _ = addSpot(name: "VRBA – Victorian Recreational Beekeepers Association", desc: "The VRBA was formed in response to the changing face of beekeeping and increasing demand from the recreational, sideline and part-time beekeepers to be able to access high quality, flexible and professional education opportunities;  Recognition of the challenges facing beekeepers responding to the needs of the recreational, sideline and part-time beekeepers;  Recreational beekeepers needing to be better represented in the community and at a Government level.", openhour: "Weekdays 7am to 7pm.", place: "All Day Carpentry Pty Ltd, Clarkefield VIC 3430", category: 1, latitude: -37.491940, longitude: 144.757090, email: "0412586659", website: "http://vrba.org.au/", image:UIImage(named:"VRBA")!)
        
         let _ = addSpot(name: "Gippsland Apiarists’ Association Inc", desc: "The GAA is based in Gippsland and services all of the Gippsland Region. There are a mixture of members both experienced and new beekeepers.", openhour: "4th Wednesday of each month at 7pm.", place: "YFC Rooms 22 Normanby Street Warragul", category: 1, latitude: -38.162520, longitude: 145.939520, email: "0408 343 779", website: "http://www.gippslandbees.org.au/", image:UIImage(named:"VRBA")!)
        
         let _ = addSpot(name: "Gippsland Apiarists’ Association Inc", desc: "The GAA is based in Gippsland and services all of the Gippsland Region. There are a mixture of members both experienced and new beekeepers.", openhour: "4th Wednesday of each month at 7pm.", place: "YFC Rooms 22 Normanby Street Warragul", category: 1, latitude: -38.162520, longitude: 145.939520, email: "0408 343 779", website: "http://www.gippslandbees.org.au/", image:UIImage(named:"GAA")!)
        
         let _ = addSpot(name: "CERES Bee Group", desc: "The CERES Bee group is open to the public for membership. As a visitor or member, we can show you all about bee-keeping, guidelines and responsibilities, industry memberships such as The Victorian Apiarists Association and practical advice on making up frames and bee hive equipment.", openhour: "3rd Sunday of every month at 10.00am.", place: "Corner Roberts & Stewart Streets, Brunswick East, VIC 3057", category: 1, latitude: -37.765100, longitude: 144.977560, email: "(+61) 3 9389 0100", website: "https://ceres.org.au/", image:UIImage(named:"CERES")!)
        
        let _ = addSpot(name: "Collingwood Children’s Farm Apiary", desc: "We aim to educate the public about bees and beekeeping as well as providing beekeeping advice and practice to current and prospective beekeepers.  We are open from 10:30 to 3:30 on the second and fourth Sunday of each month from September to May and on the last Sunday for June, July and August.", openhour: "Sunday 10:30 to 3:30.", place: "Corner Roberts & Stewart Streets, Brunswick East, VIC 3057", category: 1, latitude: -37.803393, longitude: 145.006061, email: "03 9417 5806", website: "https://www.farm.org.au/the-apiary", image:UIImage(named:"CCSFA")!)
        
         let _ = addSpot(name: "The Beekeepers Club Inc.", desc: "The Beekeepers Club is based in the Eastern suburbs of Melbourne and supports beekeepers and beekeeping with training courses, information sharing and mentoring.  We meet on the 3rd Thursday of every month at 7:30pm at our venue in Blackburn North. Regular beginners courses providing  hands on experience are held at the club apiary.", openhour: "Third Thursday of every month at 7:30pm.", place: "NewHope Community Centre: 3-7 Springfield Rd, Blackburn North", category: 1, latitude: -37.809059, longitude: 145.141894, email: "mail@beekeepers.org.au", website: "https://beekeepers.org.au/", image:UIImage(named:"TheBKClubInc")!)
        
        let _ = addSpot(name: "Perm-apiculture – Natural Beekeeping", desc: "The Perm-apiculture group formed in January 2011 as a sub-group of Permaculture Victoria (PCV). We’re a keen bunch of people based in Victoria (Australia) who are interested in beekeeping with a permaculture perspective. That is; bee-friendly, on a small scale and in a sustainable manner. We have members ranging in experience from just starting out to people who have been enthusiastically keeping bees for many years. We’re keen to swap ideas, learn from each other and to promote Natural Beekeeping. We meet on the third Monday of each month between 6:45 pm – 9 pm, except for two months – March and June.", openhour: "Third Monday of each month between 6:45 pm – 9 pm.", place: "Kew Library meeting room, Corner Cotham Road and Civic Drive, Kew", category: 1, latitude: -37.807682, longitude: 145.034530, email: "info@naturalbeekeeping.org.au", website: "http://www.naturalbeekeeping.org.au/", image:UIImage(named:"PermA")!)
        
         let _ = addSpot(name: "Geelong Beekeepers Club Inc.", desc: "Geelong Beekeepers Club aims to foster good beekeeping practice in the community, promote the interests of beekeeping and exchange information about all aspects of beekeeping. Visitors are welcome. The first visit is free; subsequent visits are $5. Or become a member! Annual membership is $30 per person.  The Geelong Beekeepers Club meets on the third Friday of every month. Meetings start at 8.00pm. They also offer “Ask a Beekeeper” which commences at 7.15 pm.", openhour: "Third Friday of every month at 8 pm.", place: "25 Regent St, Belmont VIC 3216", category: 1, latitude: -38.172958, longitude: 144.343689, email: "info@geelongbeekeepersclub.org", website: "https://geelongbeekeepersclub.org/", image:UIImage(named:"GBCI")!)
        
         let _ = addSpot(name: "Southside Beekeepers Club Inc.", desc: "Southside Beekeepers Club Inc is a not-for-profit community club for hobby beekeepers – Educating the community on all things Apiary.  We meet at Leawarra House, also known as the Elderly Citizens Club Rooms at 200 Beach Street Frankston. Setting up the hall commences from 6.30pm and all help is gratefully accepted. New Member Registrations begin from 7:00 pm. Our meetings start at 7:30 pm sharp.  Visitors and Guests are most welcome, $5 entry fee applies to non-members.", openhour: "Third Friday of every month at 8 pm.", place: "Silvertop Street, Frankston North, VIC 3200", category: 1, latitude: -38.123741, longitude: 145.147934, email: "0413 104 191", website: "https://southsidebeekeepers.com/", image:UIImage(named:"SSBKPer")!)
        
         let _ = addSpot(name: "Yarra Valley Bee Group", desc: "The Yarra Valley Bee group is a not for profit community group with an emphasis on sustainable and natural beekeeping. We support local beekeepers by facilitating monthly educational talks, workshops, mentor programs, book and equipment libraries and the Yarra Valley honey co-op. We also run educational programs for schools and other community groups. Membership is $30 a year. Meetings are held at ECOSS, 711 Old Warburton Road, Wesburn, in the newly renovated ‘Coop’ (past the old house, over the green, down the bottom).", openhour: "Last Sunday of the month 1:30 PM – 4:00 PM.", place: "at ECOSS 711 Old Warburton Rd Wesburn, Victoria, 3799", category: 1, latitude: -37.774643, longitude: 145.647766, email: "0490 663 980", website: "https://www.yarravalleybeegroup.org.au/", image:UIImage(named:"YVBG")!)
        
        
        
         
        
        
        
        
        
        
    }
    
    func createDefaultFlowers(){
        let _ = addFlower(name: "Lavender", desc: "It is grown in cool-climate zones and mainly known for its fragrance. These lasting herbs attract the bees greatly and they grow in a widespread format. It is well known to stand still in droughts, requires complete sun to grow properly, and does not like shade. Also, the soil should be sandy to rough and should be well-drained. These can be planted in a pot, container, or ground.Lavenders attract honeybees, blue-banded native bees, bumblebees, and solitary bees.", image:#imageLiteral(resourceName: "lavender"), gmonth: "12,1,2", gclimate: "Cool", pollen: "high", nectar: "high", category: "herb")
        
         let _ = addFlower(name: "Lemon balm", desc: "These herbs are known for their citrus fragrance and they can take a shape in a pot as well. They deliver a beautiful pastel yellowish colour. These plants are used in making tea with lemon flavour. They need scheduled cuttings for appropriate growth. Commonly attracted to honeybees. This plant can withstand drought and requires the sun to grow with allowable conditions of a bit of shade.Lemon balm attracts native bee species.", image: #imageLiteral(resourceName: "lemons-on-tree"), gmonth: "12,1,2,3,4", gclimate: "Cool", pollen: "low", nectar: "high", category: "herb")
        
         let _ = addFlower(name: "Grevillea montis-cole", desc: "These are rapidly increasing shrubs which have a partial vertical shape. The leaves are very beautifully shaped with zig-zag leaves structure. They support the growth of clustered red flowers. They should be reproduced by slicing from the bottom or planting the seedlings. They majorly attract honeybees. Grevillea requires maximum sun with a rainfall of around 750mm and well-drained soil. Grevillea attracts teddy bear bees and blue banded native bees.", image: #imageLiteral(resourceName: "Grevillea-flower"), gmonth: "10,11,12,1,2,3,4,5", gclimate: "Cool", pollen: "low", nectar: "low", category: "shrub")
        
        let _ = addFlower(name: "Portugal laurel", desc: "This plant will have green leaves throughout the year which will have a lustrous texture across them supporting creamy coloured spike type flowers which have a pleasing fragrance. The fruit produced from it cannot be eaten. The growing climatic conditions needed for this plant are maximum sun or partial shade along with less rainfall and can withstand drought and extremely windy conditions. This plant can be left uncut to grow as a huge bush-like structure. These plants highly attract honeybees and native bee species. ", image: #imageLiteral(resourceName: "laurel-tree"), gmonth: "10,11,12", gclimate: "Cool", pollen: "low", nectar: "high", category: "tree")
        
        
        // pants
        let _ = addFlower(name: "Oregano", desc: "It is a beautiful herb that grows its flowers within the colour band of white and purple. Its compelling smell and taste are enhanced by exposure to the sun. The more exposure the better. These herbs require engraving and slicing from the roots. It requires a cool and temperate climate along with proper sun to grow effectively. It can withstand rainfall of 500-550mm and requires well-drained soil.These plants attract bumblebees and honeybees.", image:UIImage(named: "Oregano")!, gmonth: "1,2,3,11,12", gclimate: "Cool", pollen: "no data", nectar: "high", category: "herb")
        
        let _ = addFlower(name: "Peppermint", desc: "It is a world-wide known strong herb that has many benefits such as soaked tea and traditional medicines. It does not grow much in height and allows the growth of small mauve flowers. One needs to be careful while growing this plant as its lateral shoots can hamper the growth of other nearby plants. So, while growing this plant it is vital to plant it with a container that has an open bottom and up to 50cm into the ground (around the plant) and up to 6cm above the ground. Another option might be to directly plant it in garden pots. They are majorly attracted by honeybees. It can withstand cool, temperate, and icy temperatures but cannot withstand rainfalls in a large amount. Peppermint can grow well in full sun and partially shady conditions.Peppermint attracts Australian native bees.",image:UIImage(named: "Peppermint")!, gmonth: "1,2,3,12", gclimate: "Cool", pollen: "high", nectar: "high", category: "herb")
        
//        let _ = addFlower(name: "Grevillea montis-cole", desc: "Grevillea- These are rapidly increasing shrubs which have a partial vertical shape. The leaves are very beautifully shaped with zig-zag leaves structure. They support the growth of clustered red flowers. They should be reproduced by slicing from the bottom or planting the seedlings. They majorly attract honeybees. Grevillea requires maximum sun with a rainfall of around 750mm and a well-drained soil.Grevillea attracts teddy bear bees and blue banded native bees.",
//        image:UIImage(named: "Grevillea montis-cole")!, gmonth: "1,2,3,10,11,12", gclimate: "Cool", pollen: "low", nectar: "low", category: "shrub")
        
        let _ = addFlower(name: "Flowering currants ", desc: "These are long-lasting shrubs that grow tall and every second leaf will be darker than the first one. It grows blackcurrant fruits which have got numerous marketable applications. It is significant to keep the soil moisty prior to the plantation of the plant. They should be reproduced by slicing from the bottom. It grows well in moist soil and the highest sun to partial shade conditions. Also, it is frost tolerant.These plants attract bumblebees and honey bees.",
        image:UIImage(named: "Flowering currants")!, gmonth: "9,10,11", gclimate: "Cool", pollen: "low", nectar: "high", category: "shrub")
        
        let _ = addFlower(name: "Raspberry ", desc: "These are rapidly growing plants which aid the growth of small flowers in the colour band of white to rosy. It has got numerous marketable applications. It is of ultimate significance to look after the plant or else it has high chances of spoiling the gardens with diseases and shoots. Also, please make sure to buy these plants with a certificate stating it's disease-free. It requires a cool and breezy climate to grow and not much sun. Rainfall not more than 600mm and the soil should be well-drained.These plants majorly attract honeybees and bumblebees.", image:UIImage(named: "Raspberry")!, gmonth: "1,9,10,11,12", gclimate: "Cool", pollen: "high", nectar: "high", category: "shrub")
        
        
        
        
        let _ = addFlower(name: "Blueberry ", desc: "These are rapidly growing shrubs which shed its leaves annually and have tall canes out of the roots having extremely tiny leaves with whitish cream coloured flowers which are tubular in shape. This plant has numerous commercial applications. It requires maximum sun to grow along with a cool temperature zone. These plants highly attract honey bees and carpenter bees.", image:UIImage(named: "Blueberry")!, gmonth: "1,2,3,4,5,11,12", gclimate: "Cool", pollen: "no data", nectar: "high", category: "shrub")
        
//        let _ = addFlower(name: "Portugal laurel", desc: "Portugal Laurel- This plant will have green leaves throughout the year which will have a lustrous texture across them supporting creamy coloured spike type flowers which has a pleasing fragrance. The fruit produced from it cannot be eaten. The growing climatic conditions needed for this plant are maximum sun or partial shade along with less rainfall, and can withstand drought and extreme windy conditions. This plant can be left uncut to grow as a huge bush-like structure.These plants highly attracts honeybees and native bee species.",
//        image:UIImage(named: "Portugal Laurel")!, gmonth: "10,11,12", gclimate: "Cool", pollen: "high", nectar: "low", category: "tree")
        
        let _ = addFlower(name: "Lemon", desc: "It is a small tree which will have green leaves throughout the year and assist the growth of silvery coloured flowers. It has got numerous marketable applications. It can sustain almost all of the seasons across the year with drained soil at the time of planting and it needs to be watered adequately. Lemon plants highly attract honeybees and native bee species.",
        image:UIImage(named: "Lemon")!,gmonth: "1,2,3,4,5,6,7,8,9,10,11,12", gclimate: "Cool", pollen: "high", nectar: "high", category: "tree")
        
        
        
        let _ = addFlower(name: "Apple", desc: "It is a tree which sheds its leaves annually. This is a tree with tiny beautiful white flowers with abundance, especially in premature spring. Its smaller version can be planted in a pot as well. This plant requires different plants for pollination. It attracts honeybees in a great amount. It can sustain all the climates except humid and needs full sun to shelter conditions. Apple majorly attracts honeybees.",
        image:UIImage(named: "Apple")!,gmonth: "9,10", gclimate: "Cool", pollen: "high", nectar: "low", category: "tree")
        
//        let _ = addFlower(name: "Large-fruited yellow gum", desc: "Large fruited yellow gum- It is a rapidly growing tiny tree which aids the growth of flowers in the colour band of creamy white to red. These plants are considered to be rough and tough and can sustain in any climatic conditions along with maximum sun. This plant attracts numerous bees as it makes nectar in high amounts.These plants attract honeybees, native bees, stingless bees and resin bees. ",
//            image:UIImage(named: "Large-fruited yellow gum")!, gmonth: " ", gclimate: "Cool", pollen: "no data", nectar: "no data", category: "tree")
        
        let _ = addFlower(name: "Sage", desc: "This is a long-lasting herb. It is considered to sustain rough and tough conditions with mauve coloured flowers which grow vertically. It needs to be breaded from the seedlings or by cutting the plant from the roots. It has got vital usage in traditional medicines. It can withstand all the climatic conditions with a requirement of maximum sun. These plants can be grown in pots as well. These plants highly attract honeybees and native bee species.",
        image:UIImage(named: "Sage")!, gmonth: "10,11,12", gclimate: "Temperate", pollen: "no data", nectar: "high", category: "herb")
        
        
        let _ = addFlower(name: "Borage", desc: "It is a rapidly growing herb which is considered to be rough and tough. They grow in groups and have flowers which attract the bees to have five petals and are bluish-mauve coloured. It has the ability to grow in partial shade conditions as well. It can withstand all the climatic conditions but humid and can survive with minimal water. These plants highly attract honeybees, native bee species and bumblebees.",
        image:UIImage(named: "Borage")!, gmonth: "1,2,10,11,12", gclimate: "Temperate", pollen: "high", nectar: "high", category: "herb")
        
        let _ = addFlower(name: "Winter savory Gungurra", desc: "It grows at a medium pace with the herb having green leaves throughout the year along with small flowers ranging in the colour band of white to mauve and is considered to sustain in rough and tough conditions. It has got numerous applications in the tea and medicinal industry. It can withstand minimal water but needs a good amount of sun to grow well. These plants highly attract honeybees and native bee species.",
        image:UIImage(named: "Winter savory Gungurra")!, gmonth: "1,2,12", gclimate: "Temperate", pollen: "high", nectar: "high", category: "shrub")
        
        let _ = addFlower(name: "Hairpin banksia", desc: "These shrubs growth vary from the medium-fast pace and are considered to sustain most of the climatic conditions. They produce a spiked flower that is yellowish-brown with a red centre and has a rectangular structure. These plants attract birds as well They are considered to be drought-tolerant and can grow in partial shade as well. These plants highly attract honeybees and native bee species.",
        image:UIImage(named: "Hairpin banksia")!, gmonth: "4,5,6,7,8", gclimate: "Temperate", pollen: "low", nectar: "low", category: "shrub")
        
        let _ = addFlower(name: "Pincushion hakea", desc: "It is a rapidly growing shrub which is found to be very eye-catching. These plants grow in a clustered format with a reddish centre along with creamy white spikes coming out of the bud. It can grow in almost all of the climatic conditions but requires a maximum sun and up to 500mm of rainfall. These plants highly attract stingless bees.",
        image:UIImage(named: "Pincushion hakea")!, gmonth: "4,5,6,7,8", gclimate: "Temperate", pollen: "low", nectar: "low", category: "shrub")
        
        let _ = addFlower(name: "Passionfruit", desc: "These shrubs are very attractive and can grow in all the climatic conditions but high temperature and frostiness. The flowers which these shrubs produce are multicoloured with whitish coloured leaves, mauve thread like centre and yellow flower-like structure at the centre. This plant requires a sturdy assembly for growing and grows effectively in the maximum sun. Honeybees and carpenter bees are attracted by passionfruit.",
        image:UIImage(named: "Passionfruit")!, gmonth: "2,3,4,7,8,9,10", gclimate: "Temperate", pollen: "high", nectar: "high", category: "shrub")
        
        let _ = addFlower(name: "Red cap gum", desc: "These are rapidly growing bushy trees which have multiple stems. They are extremely eye-catching plants with reddish buds and yellow flowers with a spike-like structure. These plants need to be taken care of properly by cutting and removing the unwanted shoots and stems. They cannot sustain humid conditions and grow best in the maximum sun. These plants highly attract honeybees and native bee species.",
        image:UIImage(named: "Red cap gum")!, gmonth: "3,4,5,6", gclimate: "Temperate", pollen: "high", nectar: "high", category: "tree")
        
//        let _ = addFlower(name: "Hickson mandarin Plum Persimmon", desc: "Hickson Mandarin- It is a small tree with citrusy fragrance. This tree produces waxy like creamy white flowers. They cannot sustain in extreme humid, windy conditions and clogged soils but can withstand minimal water. These trees need maximum sun for appropriate growth.These plants highly attract honeybees and native bee species.",
//        image:UIImage(named: "Hickson mandarin Plum Persimmon")!, gmonth: "8,9,10,11", gclimate: "Temperate", pollen: "high", nectar: "high", category: "tree")
        
        let _ = addFlower(name: "Coriander", desc: "These are extremely fast-growing herbs. They are widely known for their aroma and are a major component of Australian and Indian food items. They also have a vital medicinal component. These plants produce tiny flowers which lie in the colour band of white to pale pink. The most important thing to consider while having these plants in the garden is that the soil should be kept moist all the time. It requires maximum sun to partial shade sun conditions for growing and can sustain in all the temperatures except for the frost. These plants attract honeybees and solitary bees.",
        image:UIImage(named: "Coriander")!, gmonth: "12,1,2,3", gclimate: "Warm", pollen: "no data", nectar: "high", category: "herb")
        
        
        let _ = addFlower(name: "Basil", desc: "These herbs are predominantly known for their aroma. This plant can grow in a pot as well. It produces flowers which are lying in the colour range of white to mauve. The climatic conditions which this plant can sustain are cool, temperate, warm and humid and hoar frost. These plants majorly attract stingless bees.", image:UIImage(named: "Basil")!, gmonth: "1,2,3,4,5,12", gclimate: "Warm", pollen: "low", nectar: "low", category: "herb")
        
        
        let _ = addFlower(name: "Nemesia", desc: "These herbs are extremely colourful and grow in a dense manner. These plants grow throughout the year and are greatly attracted by bees because of their vibrant range of colours which it can possess in flowers some of it is blue and purple, orange and red and rosy pink. These herbs can be planted in window boxes or garden pots as well. They need the maximum sun to grow effectively and also want to be scheduled watering where over-watering should be highly avoided. It can sustain in most of the climate conditions but windy. These plants highly attract honeybees and native bee species.", image:UIImage(named: "Nemesia")!, gmonth: "1,2,3,4,5,6,7", gclimate: "Warm", pollen: "low", nectar: "low", category: "herb")
        
        let _ = addFlower(name: "Guava", desc: "This is a shrub tree and the fruit are majorly adored by most of the people. It produces fruits after 2 to 4 years from planting the seed and reaches its maximum efficiency of production at the age of 15 years. Initially, small flowers are produced as a tip of the fruit. The completely mature fruit will be assumed to have a musky aroma. This shrub requires warm to humid climate zones to grow and survive along with the plant having maximum sun. These plants highly attract honeybees and native bee species.", image:UIImage(named: "Guava")!, gmonth: "1,2,3,4,10,11,12", gclimate: "Warm", pollen: "high", nectar: "high", category: "shrub")
        
        
        let _ = addFlower(name: "Macadamia", desc: "These are shrub trees aka nuts of Queensland as they are majorly grown in sub-tropics or tropical areas. The nuts of this shrub tree are very famous and utilised in many edible food items, some may be allergic to it. These are usually small trees with leather-like leaves. It aids the growth of creamy coloured flowers which grow vertically like stems. It attains its maximum production capacity at the age of 7-8 years from the date of the plantation of the seedling. These shrub trees require the climate to be humid and warm and they can sustain frost along with rainfall of no more than 1010mm. One of the vital elements it needs for growth is the maximum sun to partial shade conditions. Macadamia plants highly attract honeybees and stingless bees.", image:UIImage(named: "Macadamia")!, gmonth: "7,8,9,10", gclimate: "Warm", pollen: "high", nectar: "high", category: "shrub")
        
        let _ = addFlower(name: "Carambola", desc: "This is a small shrub tree which grows all-round the year and it grows at a sluggish rate. Every second leaf of this small tree has a darker colour of green. The flowers produced are very beautiful and are in the colour band pink to mauve. Also, the greenish coloured fruits generated are very attractive and have a leathery outer skin which makes this tree perfect for homes and gardens. It needs the climate to be warm, humid and sunny for appropriate growth along with adequate rainfalls. Carambola plants highly attract honeybees and stingless bees.", image:UIImage(named: "Carambola")!, gmonth: "1,2,3,4,5,10,11,12", gclimate: "Warm", pollen: "no data", nectar: "high", category: "shrub")
        
        let _ = addFlower(name: "Banana", desc: "These are rapidly growing shrubs with huge leaves and flowers. The flowers of these shrubs are huge, and fruits are generated as a part of female flowers with male flowers being shed off the very next day after its opening. Two things to be careful of with these plants are its shoots which can grow horizontally underground and it generates a lot of waste. These can be a good part of the gardens as they are highly productive. Also, it demands the climate to be temperate, warm or humid throughout with its position being able to capture the full sun. These plants highly attract honeybees.", image:UIImage(named: "Banana")!, gmonth: "1,2,3,4,5,11,12", gclimate: "Warm", pollen: "high", nectar: "high", category: "shrub")
        
        let _ = addFlower(name: "Lemon-scented myrtle", desc: "It is a rapidly growing plant which is very attractive and is commonly acknowledged for its lemon-scented fragrance. The leaves and flowers of this tree contain more than 91% of citric oil. It is a wonderful addition to the garden as it will keep the garden scented and will attract a lot of bees. The flowers produced from these plants are very eye-catching and are creamy yellowish coloured with each having five petals and feather-like strands shooting out from the bottom. It demands the climate to be warm and humid along with the sun being a maximum or partial shade. The major thing to keep in mind with these trees is that it is drought intolerant hence it needs an adequate water supply. Lemon-scented myrtle plants highly attract honeybees, native bee species and stingless bees.", image:UIImage(named: "Lemon-scented myrtle")!, gmonth: "1,2,3,12", gclimate: "Warm", pollen: "low", nectar: "low", category: "tree")
        
        
        let _ = addFlower(name: "Lime", desc: "This is a small tree which grows all-year round and produces flowers and fruits throughout the year. The flowers produced are small whitish coloured with petals which are leathery and waxy. It requires maximum sun and temperature to be cool, temperate, humid or warm also, it is highly tender to frost. It can be a great part of the garden as it will keep the garden fragrant and will attract a lot of bees throughout the year. These plants highly attract honeybees.", image:UIImage(named: "Lime")!, gmonth: "1,2,3,4,5,6,7,8,9,10,11,12", gclimate: "Warm", pollen: "high", nectar: "high", category: "tree")
        
        
        let _ = addFlower(name: "Avocado", desc: "This is a moderately paced growing tree with every second leaf being darker than the first. The fruit is highly valued in the market as it possesses high nutritional values. They have a widening structure bearing light to darker green colour. The flowers produced from the tree lie in the colour range of yellow to green. It requires maximum sun to grow along with the temperature being temperate, humid or warm along with the rainfall of 600-700mm. These plants highly attract honeybees, stingless bees and solitary bees species.", image:UIImage(named: "Avocado")!, gmonth: "9,10,11", gclimate: "Warm", pollen: "high", nectar: "high", category: "tree")
        
        
        
        let _ = addFlower(name: "Bee bee tree", desc: "These are rapidly growing trees which spreads hugely and sheds its leaves every year. They have beautiful white flowers which grow in a grouped manner showing humongous flowering in the summer season. It heavily attracts bees as it is a very good source of nectar. It can sustain all the climate conditions except frost and requires maximum sun to grow. Also, it is known to tolerate drought up to a certain aspect. These plants highly attract honeybees.", image:UIImage(named: "Bee bee tree")!, gmonth: "1,2,12", gclimate: "Warm/Humid", pollen: "no data", nectar: "high", category: "tree")
        
        
        
        
        
        
//        let _ = addFlower(name: "Native hibiscus", desc: "Native Hibiscus- These are considered to sustain in rough and tough conditions. They produce beautiful flowers especially from Easter to summer. It has got typical flowers which possess five petals and needs to be taken care of else it can become messy. It requires the sun to maximum with temperatures being hot, dry or wet winters. These plants will attract the bees throughout the year. These plants highly attract native bee species.", image:UIImage(named: "Native hibiscus")!, gmonth: "1,2,3,4,5,6,7,8,9,10,11,12", gclimate: "Hot", pollen: "no data", nectar: "no data", category: "herb")
        
        
        let _ = addFlower(name: "Thyme", desc: "These are long-lasting small herbs which grow vertically and tiny mauve flowers. This plant plays a very important role in the cooking and medicinal industry due to its strong fragrance its utilised as a sprinkle/flavouring on many cuisines and also its anti-bacterial and antifungal properties are appreciated. This is recommended as one of the must haves in the herb gardens. It needs to be breaded by cutting it late-springs. These plants require highest sunny conditions for appropriate growth and can sustain all the temperature conditions except warm and frost. One of the major benefits is that these plants are insensitive to drought. These plants attract mason bees, leaf-cutter bees, honeybees and bumble bees.", image:UIImage(named: "Thyme")!, gmonth: "1,2,9,10,11,12", gclimate: "Hot", pollen: "high", nectar: "high", category: "herb")
        
        
        
        
        let _ = addFlower(name: "Spearmint", desc: "These constitute to be known as one of the oldest living mints in the world. It has got numerous marketable applications such as essential oils, chewing gums etc. These are small plants which have flowers shooting out vertically one above the other which lie in the colour range of white to pink. These plants should be planted in containers or pots as it can grow lateral shoots and spoil other plants in the garden. It is known to survive in all the climate conditions preferably in hotter and arid areas but with the sun being not too dark. These will attract bees if planted in a good quantity. These plants highly attract mining bees, yellow-faced bees, honeybees and bumble bees.", image:UIImage(named: "Spearmint")!, gmonth: "1,2,12", gclimate: "Hot", pollen: "low", nectar: "low", category: "herb")
        
        let _ = addFlower(name: "Magenta storksbill", desc: "These are long-lasting and rapidly growing herbs which produce eye-catchy flowers which lie in the colour band of pink to magenta. They are typical five petalled flowers. These plants highly attract bees due to their colours. One thing to be notified is that these plants need to be taken care of and need pruning on a regular basis. It requires maximum sun to partial shade conditions along with the temperature being cool, temperate, hot or arid. Also, these plants are frost and drought tolerant. One of the major benefits of these plants can be that they can be used as ground cover for other plants. These plants highly attract honeybees.", image:UIImage(named: "Magenta storksbill")!, gmonth: "1,2,3,4,5,11,12", gclimate: "Hot", pollen: "low", nectar: "low", category: "herb")
        
        let _ = addFlower(name: "Showy banksia", desc: "These are extremely rapidly growing herbs which possess thin long leaves having zig-zag structure. The flowers produced are large and are creamy whitish coloured sticking out from the stems. The major benefit of these plants is that they can rapidly grow after the bushfire and are insensitive to drought but are extremely fire sensitive. They require maximum sun conditions to grow along with the temperatures temperate, hot or arid. They attract bees because of the high content of pollen and nectar in them. These plants highly attract honeybees and native bee species.", image:UIImage(named: "Showy banksia")!, gmonth: "1,2,3,4,5", gclimate: "Hot", pollen: "low", nectar: "low", category: "shrub")
        
        let _ = addFlower(name: "Elegant wattle", desc: "These are medium paced growing shrub trees which are majorly found upcountry. The leaves produced are prickly and the flowers generated lie in the colour range of white to yellow. Also, the plants grow in a messy manner. Maximum flowers are produced in the months Aug- Dec. Honeybees are highly attracted to these plants. These plants require maximum sun conditions for growing along with the temperature being hot, warm or arid and are considered to be frost tolerant.", image:UIImage(named: "Elegant wattle")!, gmonth: "8,9,10", gclimate: "Hot", pollen: "no data", nectar: "no data", category: "shrub")
        
        let _ = addFlower(name: "Green mallee", desc: "It is a medium paced growing shrub tree. It is majorly known for its roots as they are utilised as an excellent source of firewood. These plants are considered to be very rough and tough and are insensitive to drought. They grow in temperate, hot or arid weather but require full sun. They produce white small flowers which are good insect and bird attractors. These plants highly attract honeybees and native bee species.", image:UIImage(named: "Green mallee")!, gmonth: "1,2,3,4,5,7,8,10,11,12", gclimate: "Hot", pollen: "low", nectar: "high", category: "shrub")
        
        let _ = addFlower(name: "Emu bush", desc: "These are desert plants and are not very attractive. The flowers produced from it are very shiny and are green and red in colour with the stamen protruding out of the flower. These can be extremely good plants to grow in desert-like conditions as they provide a high source of nectar and pollen. Another benefit of these plants is that it is very much insensitive to drought but requires maximum sun to grow. These plants majorly attract stingless bees and native bee species.", image:UIImage(named: "Emu bush")!, gmonth: "1,2,11,12", gclimate: "Hot", pollen: "low", nectar: "low", category: "shrub")
        
        let _ = addFlower(name: "Red mallee", desc: "These plants are extensively known for their oils and require temperature, hot or arid temperature conditions. The flowers produced from these plants are yellowish cream in colour. These are important for honey bee species in the western to southern part of Australia. These trees require maximum sun and are insensitive to drought. These plants highly attract honeybees and native bee species.", image:UIImage(named: "Red mallee")!, gmonth: "1,2,3,4,5,6", gclimate: "Hot", pollen: "low", nectar: "high", category: "tree")
        
//        let _ = addFlower(name: "Coral gum Desert lime", desc: "Coral gum- These plants are widely known as gum nectar or honey producer. These trees have a matt finish like pale greenish coloured leaves and beautiful, large but rough flowers. These flowers lie in the colour scale of white to coral pink and are very eye-catching for bees, but the flowers require a period of two years to grow from the date of plantation. They are highly suitable for hot and dry climate zones and require sunny to partial shade conditions. The major benefit of these plants is that they are very insensitive to drought. These plants attract a wide variety of bees such as stingless bees, native bees, blue-banded bees and carpenter bees.", image:UIImage(named: "Coral gum desert lime")!, gmonth: "8,9,10", gclimate: "Hot", pollen: "high", nectar: "high", category: "tree")
        
        let _ = addFlower(name: "Dryland tea tree", desc: "These are small shrub trees which have medium to fast paced growth. These trees are widely known for their firewood. They have cracked leaves and bottlebrushes like flowers which are whitish cream in colour and are grouped together with each other. These plants are known to sustain tough weather conditions but require a full sun to grow appropriately. The major benefit of keeping these plants in the garden are that they are less on maintenance and provide a high source of nectar and pollen. These plants highly attract honeybees.", image:UIImage(named: "Dryland tea tree")!, gmonth: "1,2,3,4,5,6,7,10,11,12", gclimate: "Hot", pollen: "high", nectar: "high", category: "tree")

    }
    
   
    func createDefaultRecords(){
        let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               let someDateTime = formatter.date(from: "2020-02-20 22:31:00")!
        let _ = addRecord(name: "watering1", type: "watering", time: someDateTime, counting: 2)
        
        let someDateTime2 = formatter.date(from: "2020-03-10 22:31:00")!
        let _ = addRecord(name: "watering2", type: "watering", time: someDateTime2, counting: 5)
        
        let someDateTime3 = formatter.date(from: "2020-03-30 22:31:00")!
        let _ = addRecord(name: "watering3", type: "watering", time: someDateTime3, counting: 3)
        
        let someDateTime4 = formatter.date(from: "2020-04-02 22:31:00")!
               let _ = addRecord(name: "watering4", type: "watering", time: someDateTime4, counting: 2)
        
        let someDateTime5 = formatter.date(from: "2020-04-20 22:31:00")!
                      let _ = addRecord(name: "watering5", type: "watering", time: someDateTime5, counting: 5)
        
        let someDateTime6 = formatter.date(from: "2020-05-10 22:31:00")!
        let _ = addRecord(name: "watering6", type: "watering", time: someDateTime6, counting: 2)
        
        let someDateTime7 = formatter.date(from: "2020-05-13 22:31:00")!
        let _ = addRecord(name: "watering7", type: "watering", time: someDateTime7, counting: 1)
        
        let someDateTime8 = formatter.date(from: "2020-05-20 22:31:00")!
        let _ = addRecord(name: "watering8", type: "watering", time: someDateTime8, counting: 4)
    }
}
