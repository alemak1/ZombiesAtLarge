//
//  Bystander.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class Bystander: SKSpriteNode{

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
            fatalError("Error: Failed to located the texture for the nonPlayerCharacterType")
        }
    
        self.init(texture: texture, color: .clear, size: texture.size())
    
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.Bystander.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.Bystander.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.Bystander.contactMask
    
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

  
    func convertToZombie(){
        
        let originalPos = position
        let originalNode = self.parent!
        
        run(SKAction.fadeAlpha(to: 0.00, duration: 3.00), completion: {
            
            self.removeFromParent()
            
            let newZombie = Zombie(zombieType: .zombie1, scale: 1.00, startingHealth: 3)
            newZombie.position = originalPos
            newZombie.move(toParent: originalNode)

        })
        
       
        
    }
   

}

