//
//  SKNode+WorldNodeSnapshot.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


/** Extension to SKNode provides convenience methods for obtaining a snapshot of the world node for the game scene; the world node snapshot can be saved as part of an overall Game Scene snapshot so as to allow for relevant game scene data to be archived and unarchived efficently **/

class WorldNodeSnapshot: NSCoding{
    
    var zombies: [Zombie]
    var collectibles: [CollectibleSprite]
    var rescueCharacters: [RescueCharacter]?
    var safetyZone: SafetyZone?
    
    init(zombies: [Zombie], collectibles: [CollectibleSprite], rescueCharacters: [RescueCharacter]?, safetyZone: SafetyZone?) {
        
        self.zombies = zombies
        self.collectibles = collectibles
        self.rescueCharacters =  rescueCharacters
        self.safetyZone = safetyZone
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.zombies, forKey: "zombies")
        aCoder.encode(self.collectibles, forKey: "collectibles")
        aCoder.encode(self.rescueCharacters, forKey: "rescueCharacters")
        aCoder.encode(self.safetyZone, forKey: "safetyZone")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.zombies = aDecoder.decodeObject(forKey: "zombies") as! [Zombie]
        self.collectibles = aDecoder.decodeObject(forKey: "collectibles") as! [CollectibleSprite]
        self.rescueCharacters = aDecoder.decodeObject(forKey: "rescueCharacters") as? [RescueCharacter]
        self.safetyZone = aDecoder.decodeObject(forKey: "safetyZone") as? SafetyZone
        
        
    }
    
}

extension SKNode{
    
    func getWorldNodeSnapshot(forMustZillZombieTrackerDelegate mustKillZombieTrackerDelegate: MustKillZombieTrackerDelegate, andForRequiredCollectibleTrackerDelegate requiredCollectibleTrackerDelegate: RequiredCollectiblesTrackerDelegate, andForUnrescuedCharacterTrackerDelegate unrescuedCharacterTrackerDelegate: UnrescuedCharacterTrackerDelegate) -> WorldNodeSnapshot{
        
        
        
        
        var zombies = [Zombie]()
        var collectibles = [CollectibleSprite]()
        var unrescuedCharacters = [RescueCharacter]()
        var safetyZone: SafetyZone?
        
        for node in children{
            
            
            /** If the zombie has not been killed and belongs in the mustKillZombie array, then it will not be stored redundantly in the world node snasphot array **/
            if let node = node as? Zombie{
                if !mustKillZombieTrackerDelegate.getMustKillZombies().contains(node){
                    zombies.append(node)
                }
            }
            
            /** If the rescue character has not been rescued and belongs in the unrescuedCharacters array, then it will not be stored redundantly in the world node snasphot array **/
            
            if let node = node as? RescueCharacter{
                if !unrescuedCharacterTrackerDelegate.getUnrescuedCharacters().contains(node){
                    unrescuedCharacters.append(node)
                }
            }
            
            /** If the collectible  has not been acquired and belongs in the requiredCollectibles array, then it will not be stored redundantly in the world node snasphot array **/
            
            
            if let node = node as? CollectibleSprite{
                if !requiredCollectibleTrackerDelegate.getRequiredCollectibles().contains(node){
                    collectibles.append(node)
                }
            }
            
            if let node = node as? SafetyZone{
                safetyZone = node
            }
            
        }
        
        let finalRescueCharacterArray = unrescuedCharacters.isEmpty ? nil : unrescuedCharacters
        
        return WorldNodeSnapshot(zombies: zombies, collectibles: collectibles, rescueCharacters: finalRescueCharacterArray, safetyZone: safetyZone)
    }
        
    
    
    func getWorldNodeSnapshot(forMustKillZombieTracker mustKillZombieTracker: MustKillZombieTracker, andForRequiredCollectibleTracker requiredCollectibleTracker: RequiredCollectiblesTracker, andForUnrescuedCharacterTracker unrescuedCharacterTracker: UnrescuedCharacterTracker) -> WorldNodeSnapshot{
        
        
        var zombies = [Zombie]()
        var collectibles = [CollectibleSprite]()
        var unrescuedCharacters = [RescueCharacter]()
        var safetyZone: SafetyZone?
        
        for node in children{
            

            /** If the zombie has not been killed and belongs in the mustKillZombie array, then it will not be stored redundantly in the world node snasphot array **/
            if let node = node as? Zombie{
                if mustKillZombieTracker.zombieHasNotBeenKilled(zombie: node){
                    zombies.append(node)
                }
            }
            
            /** If the rescue character has not been rescued and belongs in the unrescuedCharacters array, then it will not be stored redundantly in the world node snasphot array **/

            if let node = node as? RescueCharacter{
                if  unrescuedCharacterTracker.characterHasNotBeenRescued(character: node){
                    unrescuedCharacters.append(node)
                }
            }
            
            /** If the collectible  has not been acquired and belongs in the requiredCollectibles array, then it will not be stored redundantly in the world node snasphot array **/

            
            if let node = node as? CollectibleSprite{
                if  requiredCollectibleTracker.collectibleHasNotBeenAcquired(collectible: node){
                    collectibles.append(node)
                }
            }
            
            if let node = node as? SafetyZone{
                safetyZone = node
            }
            
        }
        
        let finalRescueCharacterArray = unrescuedCharacters.isEmpty ? nil : unrescuedCharacters
        
        return WorldNodeSnapshot(zombies: zombies, collectibles: collectibles, rescueCharacters: finalRescueCharacterArray, safetyZone: safetyZone)
    }
    
}
