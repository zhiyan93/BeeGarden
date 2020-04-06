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
    
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    //func onTeamChange(change: DatabaseChange, teamHeroes: [SuperHero])
    func onObserveListChange(change: DatabaseChange, observesDB: [ObserveEntity])
}
protocol DatabaseProtocol: AnyObject {
  //  var defaultList: SightEntity {get}
    
    func addObserve(name: String, desc: String, image:UIImage ,lat: Double,lon: Double, weather: String, time : Date) -> ObserveEntity
    //func addTeam(teamName: String) -> Team
   // func addHeroToTeam(hero: SuperHero, team: Team) -> Bool
    func deleteObserve(observe: ObserveEntity)
    //func deleteTeam(team: Team)
   // func removeHeroFromTeam(hero: SuperHero, team: Team)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
