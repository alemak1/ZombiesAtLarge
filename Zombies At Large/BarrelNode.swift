//
//  BarrelNode.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class BarrelNode: Shooter{
    
    
    var tankColor: TankColor!
    
    override var playFiringSound: SKAction
    {
        return SKAction.playSoundFileNamed("laser1", waitForCompletion: true)
    }
    
    /**
    override var configureBulletBitmasks: ((inout SKPhysicsBody) -> Void)?{
        
        return {(bulletPB: inout SKPhysicsBody) in
            
            bulletPB.categoryBitMask = ColliderType.PlayerBullet.rawValue
            bulletPB.collisionBitMask = ColliderType.Zombie.rawValue ^ ColliderType.Player.rawValue
            bulletPB.contactTestBitMask = ColliderType.Zombie.rawValue ^ ColliderType.Player.rawValue
            
        }
    }
    **/
    
    override var bulletSourceFile: String{
        
        guard let tankColor = self.tankColor else { return "bullet_fire1" }
        
        switch tankColor {
        case .Red:
            return "bulletRed"
        case .Green:
            return "bulletGreen"
        case .Beige:
            return "bulletBeige"
        case .Blue:
            return "bulletBlue"
        case .Black:
            return "bulletRed"
  
        }
    }
    
    var compassDirection: CompassDirection{
        didSet{
            
            guard oldValue != compassDirection else { return }
            
            let rotation = ((compassDirection.zRotation - oldValue.zRotation) <= CGFloat.pi) && (compassDirection.zRotation > oldValue.zRotation)  ? (compassDirection.zRotation - oldValue.zRotation) : -(oldValue.zRotation - compassDirection.zRotation)
            
            
            run(SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.10))
            
            
        }
    }
    
    override var appliedUnitVector: CGVector{
        
        let xUnitVector = cos(compassDirection.zRotation)
        let yUnitVector = sin(compassDirection.zRotation)
        
        return CGVector(dx: xUnitVector, dy: yUnitVector)
    }
    
    convenience init(tankColor: TankColor) {
        
        let barrelTexture = tankColor.getBarrelTexture()
        
        self.init(texture: barrelTexture, color: .clear, size: barrelTexture.size())
        
        self.name = "barrel"
        self.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        self.tankColor = tankColor
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.compassDirection = .east
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.compassDirection = .east
        
        super.init(coder: aDecoder)
    }
    
    
    public func fireBullet(){
        
        super.fireBullet(withPrefireHandler: {
            
            
        }, andWithPostfireHandler: {
            
            
        })
    }
    
    override func getBullet() -> SKSpriteNode{
        
        let bullet = super.getBullet()
        
        bullet.position = CGPoint(x: self.size.width*0.90, y: 0.00)
        
        bullet.physicsBody?.categoryBitMask = ColliderType.PlayerBullet.rawValue
        bullet.physicsBody?.collisionBitMask = ColliderType.Zombie.rawValue | ~ColliderType.Player.rawValue
        bullet.physicsBody?.contactTestBitMask = ColliderType.Zombie.rawValue | ~ColliderType.Player.rawValue
        
        return bullet
    }
    
    override func getGunfire() -> SKSpriteNode{
        
        let gunfire = super.getGunfire()
        
        gunfire.position = CGPoint(x: self.size.width*0.90, y: 0.00)
        
        return gunfire
    }
    
}
