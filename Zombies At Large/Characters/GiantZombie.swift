//
//  GiantZombie.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class GiantZombie: Zombie,Updateable{
    
    var updateInterval: Double = 3.50
    var lastMovementUpdate: Double = 0.00
    var movementFrameCount: Double = 0.00
    var gravityNode: SKFieldNode?
    
    convenience init(zombieType: ZombieType, scale: CGFloat = 1.00, startingHealth: Int = 1) {
        
        
        let defaultTexture = zombieType.getDefaultTexture()
        
        self.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        configurePhysicsProperties(withTexture: defaultTexture, andWithSize: defaultTexture.size())
        
        self.zombieType = zombieType
        self.currentHealth = startingHealth
        
        
        self.gravityNode = SKFieldNode.radialGravityField()
        gravityNode.physicsBody?.categoryBitMask = ColliderType.RepulsionField.categoryMask
        gravityNode.minimumRadius = 4.00
        addChild(gravityNode)
        
        
        self.xScale *= scale
        self.yScale *= scale
        
    }
    
    
    func updateMovement(forTime currentTime: TimeInterval){
        
        movementFrameCount = currentTime - lastMovementUpdate
        
        if(movementFrameCount > updateInterval){
            
            if let gravityNode = self.gravityNode{
                
                gravityNode.isEnabled = !gravityNode.isEnabled
                movementFrameCount = 0
            }
        }
        
        lastMovementUpdate = currentTime
        
    }
    
    
    //MARK: ********* Designated and required initializers
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
