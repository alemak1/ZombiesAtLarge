//
//  GameSceneSnapshot.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/28/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

/**
 Player Information:
     player type,
     health,
     bullets,
     compassOrientation
     position
 
 Inventory:
     types of collectibles in storage
     quantity of colelctible
     active or inactive state
 
 **/

class GameSceneSnapshot: NSObject, NSCoding{
    
    
    var date: Date!
    var gameLevelRawValue: Int!
    var playerStateSnapshot: PlayerStateSnapShot!
    var worldNodeSnapshot: WorldNodeSnapshot!
    
    var requiredCollectibles: Set<CollectibleSprite>?
    var mustKillZombies: Set<Zombie>?
    var unrescuedCharacters: Set<RescueCharacter>?
    
  
    init(gameLevel: GameLevel, playerStateSnapshot: PlayerStateSnapShot, worldNodeSnapshot: WorldNodeSnapshot, requiredCollectibles: Set<CollectibleSprite>?, mustKillZombies: Set<Zombie>?, unrescuedCharacters: Set<RescueCharacter>?) {
        
        
        self.date = Date()
        self.gameLevelRawValue = Int(gameLevel.rawValue)
        self.playerStateSnapshot = playerStateSnapshot
        self.worldNodeSnapshot = worldNodeSnapshot
        
        self.mustKillZombies = mustKillZombies
        self.unrescuedCharacters = unrescuedCharacters
        self.requiredCollectibles = requiredCollectibles
      
        super.init()

    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.gameLevelRawValue, forKey: "gameLevelRawValue")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.playerStateSnapshot, forKey: "playerStateSnapshot")
        aCoder.encode(self.worldNodeSnapshot, forKey: "worldNodeSnapshot")
        
        aCoder.encode(self.unrescuedCharacters, forKey: "unrescuedCharacters")
        aCoder.encode(self.requiredCollectibles, forKey: "requiredCollectibles")
        aCoder.encode(self.worldNodeSnapshot, forKey: "worldNodeSnapshot")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        
        let gameLevelRawValue = aDecoder.decodeObject(forKey: "gameLevelRawValue") as! Int
        self.gameLevelRawValue = gameLevelRawValue
        
        self.worldNodeSnapshot = aDecoder.decodeObject(forKey: "worldNodeSnapshot") as! WorldNodeSnapshot
        self.playerStateSnapshot = aDecoder.decodeObject(forKey: "playerStateSnapshot") as! PlayerStateSnapShot
        
        self.unrescuedCharacters = aDecoder.decodeObject(forKey: "unrescuedCharacters") as? Set<RescueCharacter>
        self.requiredCollectibles = aDecoder.decodeObject(forKey: "requiredCollectibles") as? Set<CollectibleSprite>
        self.mustKillZombies = aDecoder.decodeObject(forKey: "mustKillZombies") as? Set<Zombie>
        
        super.init()
    }
}
