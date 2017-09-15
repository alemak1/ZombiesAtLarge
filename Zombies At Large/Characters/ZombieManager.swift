//
//  ZombieManager.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/9/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class ZombieManager{
    
    var latentZombies = [Zombie]()
    var activeZombies = [Zombie]()
    
    var player: Player?
    
    var frameCount = 0.00
    var lastUpdateTime = 0.00
    
    var constraintsForActiveZombies: [SKConstraint]?{
        get{
            guard self.player != nil else { return nil}
            
            let lowerDistanceLimit = CGFloat(100.00)
            let upperDistanceLimit = CGFloat(150.0)
            
            let distanceRange = SKRange(lowerLimit: lowerDistanceLimit, upperLimit: upperDistanceLimit)
            let distanceConstraint = SKConstraint.distance(distanceRange, to: self.player!.position)
            
            let orientationRange = SKRange(lowerLimit: 0.00, upperLimit: 0.00)
            let orientationConstraint = SKConstraint.orient(to: self.player!.position, offset: orientationRange)
            
            return [distanceConstraint,orientationConstraint]
        }
    }
    
    init(withPlayer player: Player, andWithLatentZombies latentZombies:[Zombie]){
        self.player = player
        self.latentZombies = latentZombies

    }
    
    
    func addLatentZombie(zombie: Zombie){
        
        self.latentZombies.append(zombie)
        
    }
    
    /** Activates a given zombies and adds it to the list of currently active zombies **/
    
    func activateZombie(zombie: Zombie){
        
        
        zombie.activateZombie()
        activeZombies.append(zombie)
    
    }
    
    
    
    /** Update state for all zombies **/
    
    func update(withFrameCount currentTime: TimeInterval){
        
       self.frameCount = currentTime - lastUpdateTime
        
        for zombie in activeZombies {
            
            zombie.updateAnimations(withDeltaTime: frameCount)
            
        }
        
        lastUpdateTime = currentTime
    }
    
    /** Helper function that gets an array of all the zombies that are within a given node **/
    
    private func getZombiesAt(containingNode node: SKShapeNode) -> [Zombie]{
        
        
        return latentZombies.filter({ node.contains($0.position)})

    }
    
    
    /** Aligns all active zombies to follow the player and face the direction of the player **/
    
    func constrainActiveZombiesToPlayer(){
        
        for zombie in activeZombies {
            
            
            if zombie.hasBeenActivated(){

                zombie.constraints = self.constraintsForActiveZombies
                
            }
        }
        
    }
    
   
    
}
