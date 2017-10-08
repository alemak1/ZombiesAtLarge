//
//  CollectibleSprite.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/11/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class CollectibleSnapshot: NSObject, NSCoding, Saveable{
    
    var physicsBody: SKPhysicsBody
    var collectibleTypeRawValue: Int
    
    init(physicsBody: SKPhysicsBody, collectibleTypeRawValue: Int) {
        
        self.physicsBody = physicsBody
        self.collectibleTypeRawValue = collectibleTypeRawValue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.physicsBody = aDecoder.decodeObject(forKey: "physicsBody") as! SKPhysicsBody
        self.collectibleTypeRawValue = aDecoder.decodeInteger(forKey: "collectibleTypeRawValue")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.physicsBody, forKey: "physicsBody")
        aCoder.encode(self.collectibleTypeRawValue, forKey: "collectibleTypeRawValue")
    }
}

class CollectibleSprite: SKSpriteNode, Snapshottable{
    
     var collectibleType: CollectibleType!
    
    var snapshot: Saveable{
        
        let collectibleRawValue = self.collectibleType.rawValue

        return CollectibleSnapshot(physicsBody: self.physicsBody!, collectibleTypeRawValue: collectibleRawValue)
    }
    
    func getSnapshot() -> Saveable{
        
        let collectibleRawValue = self.collectibleType.rawValue
        
        return CollectibleSnapshot(physicsBody: self.physicsBody!, collectibleTypeRawValue: collectibleRawValue)
    }
    
    convenience init(collectibleSnapshot: CollectibleSnapshot) {
        
        let collectibleTypeRawValue = collectibleSnapshot.collectibleTypeRawValue
        let collectibleType = CollectibleType(rawValue: collectibleTypeRawValue)!
        
        let texture = collectibleType.getTexture()
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.collectibleType = collectibleType
        
        initializePhysicsProperties(withTexture: texture)
        
        self.xScale *= 1.00
        self.yScale *= 1.00
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        let collectibleTypeRawValue = aDecoder.decodeInteger(forKey: "collectibleTypeRawValue")
        self.collectibleType = CollectibleType(rawValue: collectibleTypeRawValue)!
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.collectibleType.rawValue, forKey: "collectibleTypeRawValue")
        super.encode(with: aCoder)
    }
    
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
    
     
   
 
}
