//
//  CamouflageZombies.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class CamouflageZombie: Zombie,Updateable{
    
    
    var updateInterval: Double = 3.50
    var lastMovementUpdate: Double = 0.00
    var movementFrameCount: Double = 0.00
    var isVisible = false
    
    
    override func hasBeenActivated() -> Bool {
        return false
    }
    
    convenience init(zombieType: ZombieType, scale: CGFloat = 1.00, startingHealth: Int = 1) {
        
        
        let defaultTexture = zombieType.getDefaultTexture()
        
        self.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        configurePhysicsProperties(withTexture: defaultTexture, andWithSize: defaultTexture.size())
        
        self.specialType = 3
        self.zombieType = zombieType
        self.currentHealth = startingHealth
        self.lightingBitMask = ColliderType.Enemy.rawValue
    
       
        self.alpha = 0.05
        self.xScale *= scale
        self.yScale *= scale
        
    }
    
    

    
    
    func updateMovement(forTime currentTime: TimeInterval){
        
        if(lastMovementUpdate == 0){
            lastMovementUpdate = currentTime
        }
        
        
        movementFrameCount += currentTime - lastMovementUpdate
        
        if(movementFrameCount > updateInterval){
            
            isVisible = !isVisible
            self.alpha = isVisible ? 0.60 : 0.10
            
            movementFrameCount = 0
            
        }
        
        lastMovementUpdate = currentTime
        
    }
    

}
