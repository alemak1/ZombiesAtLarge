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
    
    
  
    var miniZombies = [MiniZombie]()
    var giantZombies = [GiantZombie]()
    var camouflageZombies = [CamouflageZombie]()

    var dynamicZombies = [Updateable]()
    
    var latentZombies = [Zombie]()
    var activeZombies = [Zombie]()
    
    var player: Player?
    
    var frameCount = 0.00
    var lastUpdateTime = 0.00
    
    var playerIsInvisibileFrameCount = 0.00
    var playerIsInvisibleInterval = 10.00
    var playerIsInvisible = false
    
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

        NotificationCenter.default.addObserver(self, selector: #selector(makePlayerInvisibleToZombies(notification:)), name: Notification.Name.GetDidActivateCollectibleNotificationName(), object: nil)
    }
    
    
    func addLatentZombie(zombie: Zombie){
        
        self.latentZombies.append(zombie)
        
    }
    
    
    func addSpecialZombie(zombie: Zombie){
        
        switch zombie.self {
        case is GiantZombie:
            print("Adding a giant zombie")
            self.giantZombies.append(zombie as! GiantZombie)
            break
        case is MiniZombie:
            print("Adding a mini zombie")
            self.miniZombies.append(zombie as! MiniZombie)
            break
        case is CamouflageZombie:
            print("Adding a camouflage zombie")
            self.camouflageZombies.append(zombie as! CamouflageZombie)
            break
        default:
            print("")
        }
    }
    
    @objc func makePlayerInvisibleToZombies(notification: Notification?){
        
       
        if let userInfo = notification?.userInfo, let rawValue = userInfo["collectibleRawValue"] as? Int, let collectibleType = CollectibleType(rawValue: rawValue), collectibleType == .BeakerRed, let isActive = userInfo["isActive"] as? Bool, isActive{
            
            playerIsInvisible = true
        }
        
    }
    
  
    func addCamouflageZombie(zombie: CamouflageZombie){
        self.camouflageZombies.append(zombie)
    }
    
    func addMiniZombie(zombie: MiniZombie){
        self.miniZombies.append(zombie)
    }
    
    
    func addGiantZombie(zombie: GiantZombie){
        self.giantZombies.append(zombie)
    }
    
    func addDynamicZombie(zombie: Updateable){
        self.dynamicZombies.append(zombie)
    }
    
    /** Activates a given zombies and adds it to the list of currently active zombies **/
    
    func activateZombie(zombie: Zombie){
        
        
        zombie.activateZombie()
        activeZombies.append(zombie)
    
    }
    
    
    
    /** Update state for all zombies **/
    
    func update(withFrameCount currentTime: TimeInterval){
        

        for zombie in self.activeZombies {
            
            zombie.updateAnimations(withDeltaTime: currentTime)
            
        }
        
        for zombie in self.dynamicZombies{
            
            
            zombie.updateMovement(forTime: currentTime)
            
        }
        
   
        if(playerIsInvisible){
            
            if(lastUpdateTime == 0){
                lastUpdateTime = currentTime
            }

            playerIsInvisibileFrameCount += currentTime - lastUpdateTime
            
            print("Player is invisibile with frameCount of \(playerIsInvisibileFrameCount)")
            
            if(playerIsInvisibileFrameCount > playerIsInvisibleInterval){
                
                playerIsInvisible = false
                playerIsInvisibileFrameCount = 0.00
                
                let userInfo: [String:Any] = [
                    "collectibleRawValue":CollectibleType.BeakerRed.rawValue,
                    "isActive": false
                ]
                
                NotificationCenter.default.post(name: Notification.Name.GetDidActivateCollectibleNotificationName(), object: nil, userInfo: userInfo)
                
                
            }
            
            lastUpdateTime = currentTime

        }
        
        
    }
    
    /** Helper function that gets an array of all the zombies that are within a given node **/
    
    private func getZombiesAt(containingNode node: SKShapeNode) -> [Zombie]{
        
        
        return latentZombies.filter({ node.contains($0.position)})

    }
    
    
    /** Aligns all active zombies to follow the player and face the direction of the player **/
    
    func constrainActiveZombiesToPlayer(){
        
        for zombie in activeZombies {
            
            
            if zombie.hasBeenActivated() && !playerIsInvisible{

                zombie.constraints = self.constraintsForActiveZombies
                
            }
        }
        
    }
    
   
    
}
