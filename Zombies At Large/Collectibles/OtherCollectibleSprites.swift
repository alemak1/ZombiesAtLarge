//
//  OtherCollectibleSprites.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/16/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: CollectibleSprite{
    
    var numberOfBullets: Int = 1
    
    convenience init(numberOfBullets: Int = 1) {
        
        let bulletTexture = CollectibleType.Bullet1.getTexture()
        
        self.init(texture: bulletTexture, color: .clear, size: bulletTexture.size())
        initializePhysicsProperties(withTexture: bulletTexture)
        
        self.numberOfBullets = numberOfBullets
        
        self.name = CollectibleType.Bullet1.getCollectibleName()
        self.collectibleType = CollectibleType.Bullet1
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class RedEnvelope: CollectibleSprite{
    
    var monetaryValue: Double = 100
    
    convenience init(monetaryValue: Double? = nil) {
        
        let redEnvelopeTexture = CollectibleType.RedEnvelope1.getTexture()
        
        self.init(texture: redEnvelopeTexture, color: .clear, size: redEnvelopeTexture.size())
        initializePhysicsProperties(withTexture: redEnvelopeTexture)
        self.monetaryValue = monetaryValue ?? CollectibleType.RedEnvelope1.getMonetaryUnitValue()
        self.name = CollectibleType.RedEnvelope1.getCollectibleName()
        self.collectibleType = CollectibleType.RedEnvelope1

    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RiceBowl: CollectibleSprite{
    
    var healthValue: Int = 2
    
    convenience init(healthValue: Int? = 2) {
        
        let riceBowlTexture = CollectibleType.RiceBowl1.getTexture()
        
        self.init(texture: riceBowlTexture, color: .clear, size: riceBowlTexture.size())
        initializePhysicsProperties(withTexture: riceBowlTexture)
        self.healthValue = healthValue ?? 2
        self.name = CollectibleType.RiceBowl1.getCollectibleName()
        self.collectibleType = CollectibleType.RiceBowl1
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Bomb: CollectibleSprite{
    
    var playBombExplosionSound = SKAction.playSoundFileNamed("explosion2", waitForCompletion: false)
    
    lazy var bombExplosionAnimation = {
        
        return SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion00")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion01")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion02")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion03")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion04")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion05")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion07")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion08"))
            
            ], timePerFrame: 0.10)
        
    }()
    
    public func runExplosionAnimation(){
        
        run(SKAction.group([self.playBombExplosionSound,self.bombExplosionAnimation]), completion: {

            self.removeFromParent()
           
        })
    }
    
    convenience init(scale: CGFloat) {
        
        let bombTexture = CollectibleType.Bomb.getTexture()
        
        self.init(texture: bombTexture, color: .clear, size: bombTexture.size())
        self.initializePhysicsProperties(withTexture: bombTexture)
        self.name = CollectibleType.Bomb.getCollectibleName()
        self.collectibleType = CollectibleType.Bomb
        
        self.xScale *= scale
        self.yScale *= scale 
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     override func initializePhysicsProperties(withTexture texture: SKTexture) {
            self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
            self.physicsBody?.categoryBitMask = ColliderType.Bomb.categoryMask
            self.physicsBody?.collisionBitMask = ColliderType.Bomb.collisionMask
            self.physicsBody?.contactTestBitMask = ColliderType.Bomb.contactMask
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.linearDamping = 2.00
            self.physicsBody?.allowsRotation = false
            self.physicsBody?.isDynamic = true
        
        
        
    }
}
