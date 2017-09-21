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
    
    
    
    
    convenience init(zombieType: ZombieType, scale: CGFloat = 1.00, startingHealth: Int = 1) {
        
        
        let defaultTexture = zombieType.getDefaultTexture()
        
        self.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        configurePhysicsProperties(withTexture: defaultTexture, andWithSize: defaultTexture.size())
        
        self.zombieType = zombieType
        self.currentHealth = startingHealth
        
        self.xScale *= scale
        self.yScale *= scale
        
    }
    
    
    func updateMovement(forTime currentTime: TimeInterval){
        
        
    }
    
    
    //MARK: ********* Designated and required initializers
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
