//
//  Collectible.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class Collectible: SKSpriteNode{
    
    private var collectibleType: CollectibleType!
    
    convenience init(collectibleType: CollectibleType,scale: CGFloat = 1.00) {
        
        let texture = collectibleType.getTexture()
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.collectibleType = collectibleType
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.Collectible.rawValue
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        self.xScale *= scale
        self.yScale *= scale 

    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getMonetaryValue() -> Double{
        return self.collectibleType.getMonetaryValue()
    }
    
}
