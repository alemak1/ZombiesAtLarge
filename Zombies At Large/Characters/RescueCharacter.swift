//
//  RescueCharacter.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/17/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class RescueCharacter: SKSpriteNode{
    
    var nonPlayerCharacterType: NonplayerCharacterType!
    
    var compassDirection: CompassDirection!{
        didSet{
            
            guard oldValue != compassDirection else { return }
            
            let rotation = ((compassDirection.zRotation - oldValue.zRotation) <= CGFloat.pi) && (compassDirection.zRotation > oldValue.zRotation)  ? (compassDirection.zRotation - oldValue.zRotation) : -(oldValue.zRotation - compassDirection.zRotation)
            
            
            run(SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.10))
            
            
        }
    }
    
    convenience init(nonPlayerCharacterType: NonplayerCharacterType) {
      
        
        guard let texture = nonPlayerCharacterType.getTexture() else {
            fa
        }
        
        self.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.RescueCharacter.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.RescueCharacter.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.RescueCharacter.contactMask
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 1.00
        self.physicsBody?.angularDamping = 0.00
        
        self.nonPlayerCharacterType = nonPlayerCharacterType
        self.compassDirection = .east
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
