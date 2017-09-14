//
//  CollectibleSprite.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/11/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class CollectibleSprite: SKSpriteNode{

     var collectibleType: CollectibleType!
    
     convenience init(collectibleType: CollectibleType,scale: CGFloat = 1.00) {
     
     let texture = collectibleType.getTexture()
     
     self.init(texture: texture, color: .clear, size: texture.size())
     
     self.collectibleType = collectibleType
     
    initializePhysicsProperties(withTexture: texture)
        
     self.xScale *= scale
     self.yScale *= scale
     
     }
    
    public func initializePhysicsProperties(withTexture texture: SKTexture){
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.Collectible.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.Collectible.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.Collectible.contactMask
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        
    }
    
    
    public func getCollectible() -> Collectible{
        
        return Collectible(withCollectibleType: self.collectibleType)
    
    }
     
     override init(texture: SKTexture?, color: UIColor, size: CGSize) {
     super.init(texture: texture, color: color, size: size)
     
     
     }
    
     
     required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }
 
}
