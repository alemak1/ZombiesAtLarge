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
    
    
    override func hasBeenActivated() -> Bool {
        return false
    }
    
    convenience init(zombieType: ZombieType, scale: CGFloat = 3.00, startingHealth: Int = 1) {
        
        
        let defaultTexture = zombieType.getDefaultTexture()
        
        
        self.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        configurePhysicsProperties(withTexture: defaultTexture, andWithSize: defaultTexture.size())
        
        self.specialType = 1
        self.zombieType = zombieType
        self.currentHealth = startingHealth
        
    
        self.gravityNode = SKFieldNode.radialGravityField()
        self.gravityNode!.physicsBody?.categoryBitMask = ColliderType.RepulsionField.categoryMask
        self.gravityNode!.minimumRadius = 0.0
        self.gravityNode?.falloff = 1.00
        self.gravityNode!.isEnabled = false
        addChild(gravityNode!)
     
 
        
        self.xScale *= scale
        self.yScale *= scale
        
        let zombieRed = UIColor(displayP3Red: 200.0/255.0, green: 100.0/255.0, blue: 10.0/255.0, alpha: 0.5)

        run(SKAction.colorize(with: zombieRed, colorBlendFactor: 1.00, duration: 0.10))
    }
    
    
    func updateMovement(forTime currentTime: TimeInterval){
        
        if(lastMovementUpdate == 0){
            lastMovementUpdate = currentTime
        }
        
        
        movementFrameCount += currentTime - lastMovementUpdate
        
        if(movementFrameCount > updateInterval){
            
            if let gravityNode = self.gravityNode{
               // gravityNode.isEnabled = !gravityNode.isEnabled
            }
            
            self.physicsBody?.applyAngularImpulse(0.50)

           
            
            movementFrameCount = 0

        }
        
        lastMovementUpdate = currentTime
        
    }
    
    override func configurePhysicsProperties(withTexture texture: SKTexture, andWithSize size: CGSize) {
        super.configurePhysicsProperties(withTexture: texture, andWithSize: size)
        
        self.physicsBody!.isDynamic = true
        self.physicsBody!.allowsRotation = true
        self.physicsBody?.angularDamping = 4.00
        
    }
    
    override func die(completion: (() -> Void)?) {
        
        super.die(completion: {
            if self.currentHealth <= 0{
                print("Giant Zombie has died...sending notification...")
                
                let notificationName = Notification.Name(rawValue: Notification.Name.didKillMustKillZombieNotification)
                
                NotificationCenter.default.post(name: notificationName, object: self, userInfo: [
                    "zombieName":self.name ?? "MustKillZombie"
                    ])
                
            }
            
        })
        
    }
    
   
    
 
    
   
    
    //MARK: ********* Designated and required initializers
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
