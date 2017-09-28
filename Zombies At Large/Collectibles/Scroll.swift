//
//  Scroll.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/28/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class Scroll: SKSpriteNode{
    
    var scrollConfiguration: ScrollConfiguration!
    
    convenience init(scrollConfiguration: ScrollConfiguration) {
        
        let randomIdx = Int(arc4random_uniform(UInt32(Scroll.allTextTypes.count)))
        let textType = Scroll.allTextTypes[randomIdx]
        let texture = textType.getTexture()
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        initializePhysicsProperties(withTexture: texture)
        
    }
    
    public func initializePhysicsProperties(withTexture texture: SKTexture){
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.Collectible.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.Collectible.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.Collectible.contactMask
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Scroll{
    
    static let allTextTypes: [CollectibleType] = [CollectibleType.Clipboard,CollectibleType.ClosedBook]
    
}
