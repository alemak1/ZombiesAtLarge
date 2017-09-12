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
    
    
    /** Activates a given zombies and adds it to the list of currently active zombies **/
    
    func activateZombie(zombie: Zombie){
        
        print("Activiating zombie....")
        
        zombie.activateZombie()
        activeZombies.append(zombie)
    
    }
    
    
    /** Checks for any latent zombies close to player; if zombies are within the player proximity zone, they are activated **/
    
    func checkForZombiesInPlayerProximity(){
        
        guard let player = self.player else { return }
        
        let nearbyZombies: [Zombie] = getZombiesAt(containingNode: player.getPlayerProximityNode())
        
        print("The number of nearby zombies is: \(nearbyZombies.count)")
        
        if !nearbyZombies.isEmpty{
            
            print("There are zombies nearby!")
            
            for zombie in nearbyZombies{
                activateZombie(zombie: zombie)
            }
        }
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
    
    private func getZombiesAt(containingNode node: SKSpriteNode) -> [Zombie]{
        print("Testing for zombies in the playerProximityNode")
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
