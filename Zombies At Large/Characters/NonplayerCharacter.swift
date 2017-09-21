//
//  NonplayerCharacter.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class NonplayerCharacter: SKSpriteNode{
    
    var nonPlayerCharacterType: NonplayerCharacterType!
    
    
    var compassDirection: CompassDirection!{
        didSet{
            
            guard oldValue != compassDirection else { return }
            
            let rotation = ((compassDirection.zRotation - oldValue.zRotation) <= CGFloat.pi) && (compassDirection.zRotation > oldValue.zRotation)  ? (compassDirection.zRotation - oldValue.zRotation) : -(oldValue.zRotation - compassDirection.zRotation)
            
            
            run(SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.10))
            
            
        }
    }
    
    
   
    convenience init(nonPlayerCharacterType: NonplayerCharacterType, andName name: String) {
        
        
        guard let texture = nonPlayerCharacterType.getTexture() else {
            fatalError("Error: Failed to located the texture for the nonPlayerCharacterType")
        }
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.NonPlayerCharacter.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.NonPlayerCharacter.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.NonPlayerCharacter.contactMask
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 1.00
        self.physicsBody?.angularDamping = 0.00
        
        self.nonPlayerCharacterType = nonPlayerCharacterType
        self.compassDirection = .east
        
        self.name = name
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
 
    
   
}
