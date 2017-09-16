//
//  Shooter.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/9/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class Shooter: SKSpriteNode{
    
    var bulletInTransit: Bool
    
    var playFiringSound: SKAction{
        return SKAction()
    }
    
    var appliedUnitVector: CGVector{
        return CGVector.zero
    }
    
    var gunfireSourceFile: String{
        
        return "bullet_fire2"
    }
    
    var bulletSourceFile: String{
        return "bullet_fire1"
    }
    
    /** For demonstration only **/
    
    var configureBulletBitmasks: ((inout SKPhysicsBody) -> Void)?{
        return nil
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        bulletInTransit = false
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func fireBullet(withPrefireHandler prefireHandler: @escaping (() -> (Void)), andWithPostfireHandler postfireHandler: @escaping (() -> (Void))){
        
        guard !bulletInTransit else { return }
        
        let bullet = getBullet()
        let gunfire = getGunfire()
        
        let bulletMagnitude = CGFloat(10.00)
        
        let cgVector = CGVector(dx: bulletMagnitude*self.appliedUnitVector.dx, dy: bulletMagnitude*self.appliedUnitVector.dy)
        
        
        self.run(SKAction.sequence([
            
            SKAction.run {
                prefireHandler()

            },
            
            SKAction.run {
                
                
                self.bulletInTransit = true
                
                if(self.parent != nil){
            
                    bullet.zRotation = self.zRotation
                    let adjustedPos = self.parent!.convert(bullet.position, from: self)
                    self.parent!.addChild(bullet)
                    bullet.position = adjustedPos
                
                    self.addChild(gunfire)
                
                    bullet.physicsBody?.applyImpulse(cgVector)
                }
                
            },
            
            SKAction.sequence([
                SKAction.wait(forDuration: 0.05),
                SKAction.run { gunfire.removeFromParent()
                    self.bulletInTransit = false
                    
                }
                ]),
            
            self.playFiringSound,
            
            SKAction.run {
                bullet.removeFromParent()
            },
            
            SKAction.run {
                postfireHandler()
            }
            
            ]))
        
        
        print("Gun fired by zombie!")
    }
    
    
    func getGunfire() -> SKSpriteNode{
        
        let spriteWidth = size.width
        let spriteHeight = size.height
        
        let gunfire = SKSpriteNode(imageNamed: self.gunfireSourceFile)
        gunfire.position = CGPoint(x: spriteWidth*0.43, y: -spriteHeight*0.17)
        
        return gunfire
    }
    
     func getBullet() -> SKSpriteNode{
        
        let spriteWidth = size.width
        let spriteHeight = size.height
        
        
        let bulletTexture = SKTexture(imageNamed: self.bulletSourceFile)
        let bullet = SKSpriteNode(texture: bulletTexture)
        
        bullet.physicsBody = SKPhysicsBody(texture: bulletTexture, size: bulletTexture.size())
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.allowsRotation = false
        bullet.physicsBody?.linearDamping = 0.50
        
        if let configureBulletBitMasks = self.configureBulletBitmasks, var physicsBody = bullet.physicsBody{
            
                configureBulletBitMasks(&physicsBody)
            
        }
        
        bullet.position = CGPoint(x: spriteWidth*0.43, y: -spriteHeight*0.17)
        
        return bullet
    }
    
    
    
}
