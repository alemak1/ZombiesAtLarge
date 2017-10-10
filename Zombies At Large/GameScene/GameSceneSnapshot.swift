//
//  GameSceneSnapshot.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/28/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class GameSceneSnapshot{
    
}
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

/**
class GameSceneSnapshot: NSObject, NSCoding{
    
    
    var date: Date!
    var gameLevelRawValue: Int!
    var playerStateSnapshot: PlayerStateSnapShot!
    var worldNodeSnapshot: WorldNodeSnapshotA!
    
    var requiredCollectibles: [CollectibleSnapshot]?
    var unrescuedCharacters: [RescueCharacterSnapshot]?
    
  
    init(gameLevel: GameLevel, playerStateSnapshot: PlayerStateSnapShot, worldNodeSnapshot: WorldNodeSnapshotA, requiredCollectibles: [CollectibleSnapshot]?, mustKillZombies: [ZombieSnapshot]?, unrescuedCharacters:[RescueCharacterSnapshot]? ) {
        
        print("Initializing a new game snapshot with game level raw value equal to \(gameLevel.rawValue)")
        
        self.date = Date()
        self.gameLevelRawValue = gameLevel.rawValue
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
        
        let gameLevelRawValue = aDecoder.decodeInt64(forKey: "gameLevelRawValue")
        self.gameLevelRawValue = Int(gameLevelRawValue)
        
        self.worldNodeSnapshot = aDecoder.decodeObject(forKey: "worldNodeSnapshot") as! WorldNodeSnapshotA
        self.playerStateSnapshot = aDecoder.decodeObject(forKey: "playerStateSnapshot") as! PlayerStateSnapShot
        
        self.unrescuedCharacters = aDecoder.decodeObject(forKey: "unrescuedCharacters") as? [RescueCharacterSnapshot]
        self.requiredCollectibles = aDecoder.decodeObject(forKey: "requiredCollectibles") as? [CollectibleSnapshot]
        self.mustKillZombies = aDecoder.decodeObject(forKey: "mustKillZombies") as? [ZombieSnapshot]
        
        super.init()
    }
}
**/
