//
//  UnrescuedCharacterTrackerDelegate.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

protocol UnrescuedCharacterTrackerDelegate{
    
    var unrescuedCharacters: Set<RescueCharacter> {set get}
    
    var numberOfUnrescuedCharacters: Int { get }
    
    func removeUnrescuedCharacter(rescueCharacter: RescueCharacter)
    
    func addUnrescuedCharacters(rescueCharacter: RescueCharacter)
    
    func constraintRescuedCharactersToPlayer()
    
    func checkSafetyZoneForRescueCharacterProximity(safetyZone: SKSpriteNode)
    
}
