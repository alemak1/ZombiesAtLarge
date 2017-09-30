//
//  SceneManager.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class SceneManager{
    
    static let sharedManager = SceneManager()
    
    
    var zombieManager: ZombieManager?
    
    var requiredCollectibles: Set<CollectibleSprite> = []
    
    var numberOfRequiredCollectibles: Int{
        return requiredCollectibles.count
    }
    
    
    var unrescuedCharacters: Set<RescueCharacter> = []
    
    var numberOfUnrescuedCharacters: Int{
        return unrescuedCharacters.count
    }
    
    
    
    var mustKillZombies: Set<Zombie> = []
    
    var numberOfMustKillZombies: Int{
        return mustKillZombies.count
    }
    
    
    private init(){
        
        
    }
    
    
  
    
    func addLatentZombie(zombie: Zombie){
        
        self.zombieManager?.addLatentZombie(zombie: zombie)
        
    }
    
    
    func addSpecialZombie(zombie: Zombie){
        
        self.zombieManager?.addSpecialZombie(zombie: zombie)
        
    }
    
    
    func addCamouflageZombie(zombie: CamouflageZombie){
        self.zombieManager?.addCamouflageZombie(zombie: zombie)
    }
    
    func addMiniZombie(zombie: MiniZombie){
        self.zombieManager?.addMiniZombie(zombie: zombie)
    }
    
    
    func addGiantZombie(zombie: GiantZombie){
        self.zombieManager?.addGiantZombie(zombie: zombie)
    }
    
    func addDynamicZombie(zombie: Updateable){
        self.zombieManager?.addDynamicZombie(zombie: zombie)
    }
    
    /** Activates a given zombies and adds it to the list of currently active zombies **/
    
    func activateZombie(zombie: Zombie){
        
        zombieManager?.activateZombie(zombie: zombie)
        
    }
    
    
    
    /** Update state for all zombies **/
    
    func update(withFrameCount currentTime: TimeInterval){
        
        zombieManager?.update(withFrameCount: currentTime)
        
    }
    
    /** Helper function that gets an array of all the zombies that are within a given node **/
    
    
    /** Aligns all active zombies to follow the player and face the direction of the player **/
    
    func constrainActiveZombiesToPlayer(){
        
        zombieManager?.constrainActiveZombiesToPlayer()
    }
    
    
}
