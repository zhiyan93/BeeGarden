//
//  DatabaseProtocol.swift
//  BeeGarden
//
//  Created by steven liu on 4/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import Foundation
import UIKit

enum DatabaseChange {
    case add
    case remove
    case update
}
enum ListenerType {
    case observe
    case plantRecord
    case bee
    case flower
    case knowledge
    case spot
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    //func onTeamChange(change: DatabaseChange, teamHeroes: [SuperHero])
    func onObserveListChange(change: DatabaseChange, observesDB: [ObserveEntity])
    func onBeeListChange(change: DatabaseChange, beesDB: [BeeEntity])
    func onKnowledgeListChange(change: DatabaseChange, knowsDB: [KnowledgeEntity])
    func onSpotListChange(change: DatabaseChange,spotsDB:[SpotEntity])
    func onFlowerListChange(change:DatabaseChange,flowersDB:[FlowerEntity])
    func onRecordListChange(change:DatabaseChange,recordsDB:[PlantRecordEntity])
}
protocol DatabaseProtocol: AnyObject {
  //  var defaultList: SightEntity {get}
    
    func addObserve(name: String, desc: String, image:UIImage ,lat: Double,lon: Double, weather: String, time : Date) -> ObserveEntity
    //func addTeam(teamName: String) -> Team
   // func addHeroToTeam(hero: SuperHero, team: Team) -> Bool
    func deleteObserve(observe: ObserveEntity)
//   func deleteTeam(team: Team)
//    func removeHeroFromTeam(hero: SuperHero, team: Team)
    func addBee(name:String,desc:String,image:UIImage) ->BeeEntity
    func deleteBee(bee:BeeEntity)
    
    func addKnow(name:String,desc:String,time:Date, image:UIImage) ->KnowledgeEntity
    func deleteKnow(know:KnowledgeEntity)

    func addSpot(name:String,desc:String,openhour:String,place:String,category:Int,latitude:Double,longitude:Double,email:String,website:String,image: UIImage) -> SpotEntity
    func deleteSpot(spot:SpotEntity)
    
    func addFlower(name:String,desc:String,image: UIImage,gmonth:String,gclimate:String,pollen:String,nectar:String,category:String) -> FlowerEntity
    func deleteFlower(flower:FlowerEntity)
    
    func addRecord(name: String,type:String,time:Date,counting:Int) -> PlantRecordEntity
    func deleteRecord(record:PlantRecordEntity)
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
