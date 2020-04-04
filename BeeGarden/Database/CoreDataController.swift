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
            createDefaultEntries()
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
    
    func addObserve(name: String, desc: String, image: String, lat: Double , lon: Double,weather:String, time: Date) -> ObserveEntity {
        let observe = NSEntityDescription.insertNewObject(forEntityName: "ObserveEntity", into:
            persistantContainer.viewContext) as! ObserveEntity
        observe.name = name
        observe.desc = desc
        observe.image = image
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
    
   
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.observe  {
            listener.onObserveListChange(change: .update, observesDB: fetchAllBeeObserve())
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
    
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allObservesFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.observe  {
                    listener.onObserveListChange(change: .update, observesDB: fetchAllBeeObserve())
                }
            }
        }
        
    }
    
  // var defaultList: SightEntity
    
    func createDefaultEntries() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "2019/10/08 22:31:00")!
        //let _ = addSuperHero(name: "Bruce Wayne", abilities: "Is Rich")
        let _ = addObserve(name: "Honey Bee", desc: "keeped by farmer", image: "honey_bee", lat: -37.1, lon: 144.5, weather: "sunny", time: someDateTime)
        
      
    }
}
