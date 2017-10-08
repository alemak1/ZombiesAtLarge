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
    
    required init?(coder aDecoder: NSCoder) {
        self.numberOfBullets = aDecoder.decodeInteger(forKey: "numberOfBullets")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.numberOfBullets, forKey: "numberOfBullets")
    }
    
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
    
   
}


class RedEnvelopeSnapshot: NSObject, NSCoding,Saveable{
    
    var monetaryValue: Double
    var physicsBody: SKPhysicsBody
    
    init(monetaryValue: Double, physicsBody: SKPhysicsBody) {
        self.monetaryValue = monetaryValue
        self.physicsBody = physicsBody
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.monetaryValue = aDecoder.decodeDouble(forKey: "monetaryValue")
        self.physicsBody = aDecoder.decodeObject(forKey: "physicsBody") as! SKPhysicsBody
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.monetaryValue, forKey:"monetaryValue")
        aCoder.encode(self.physicsBody, forKey: "physicsBody")
    }
}

class RedEnvelope: CollectibleSprite{
    
    
    override var snapshot: Saveable{
        return RedEnvelopeSnapshot(monetaryValue: self.monetaryValue, physicsBody: self.physicsBody!)

    }
    
    override func getSnapshot() -> Saveable {
        
        return RedEnvelopeSnapshot(monetaryValue: self.monetaryValue, physicsBody: self.physicsBody!)
    }
    
    var monetaryValue: Double = 100
    
    required init?(coder aDecoder: NSCoder) {
        self.monetaryValue = aDecoder.decodeDouble(forKey: "monetaryValue")
        super.init(coder: aDecoder)
    }

    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.monetaryValue, forKey: "monetaryValue")
        super.encode(with: aCoder)
        
    }
    
    convenience init(redEnveloperSnapshot: RedEnvelopeSnapshot) {
        
        let redEnvelopeTexture = CollectibleType.RedEnvelope1.getTexture()
        
        self.init(texture: redEnvelopeTexture, color: .clear, size: redEnvelopeTexture.size())
        initializePhysicsProperties(withTexture: redEnvelopeTexture)
        self.monetaryValue = redEnveloperSnapshot.monetaryValue
        self.name = CollectibleType.RedEnvelope1.getCollectibleName()
        self.collectibleType = CollectibleType.RedEnvelope1
    }
    
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
    
}


class RiceBowlSnapshot: NSObject, NSCoding, Saveable{
    
    var healthValue: Int
    var physicsBody: SKPhysicsBody
    
    init(healthValue: Int, physicsBody: SKPhysicsBody) {
        self.healthValue = healthValue
        self.physicsBody = physicsBody
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.healthValue = aDecoder.decodeInteger(forKey: "healthValue")
        self.physicsBody = aDecoder.decodeObject(forKey: "physicsBody") as! SKPhysicsBody
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.healthValue, forKey: "healthValue")
        aCoder.encode(self.physicsBody, forKey: "physicsBody")
    }
    
}


class RiceBowl: CollectibleSprite{
    
    var healthValue: Int = 2
    
    
    override var snapshot: Saveable{
        return RiceBowlSnapshot(healthValue: self.healthValue, physicsBody: self.physicsBody!)
    }
    
    override func getSnapshot() -> Saveable {
        return RiceBowlSnapshot(healthValue: self.healthValue, physicsBody: self.physicsBody!)
        
    }
    convenience init(riceBowlSnapshot: RiceBowlSnapshot) {
        
        let riceBowlTexture = CollectibleType.RiceBowl1.getTexture()
        
        self.init(texture: riceBowlTexture, color: .clear, size: riceBowlTexture.size())
        initializePhysicsProperties(withTexture: riceBowlTexture)
        self.healthValue = riceBowlSnapshot.healthValue
        self.name = CollectibleType.RiceBowl1.getCollectibleName()
        self.collectibleType = CollectibleType.RiceBowl1
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.healthValue = aDecoder.decodeInteger(forKey: "healthValue")
        super.init(coder: aDecoder)
        
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(healthValue, forKey: "healthValue")
    }
    
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
    
    
}

class BombSnapshot: NSObject, NSCoding, Saveable{
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
    
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
}

class Bomb: CollectibleSprite{
    
    override var snapshot: Saveable{
        return BombSnapshot()

    }
    
    override func getSnapshot() -> Saveable {
        return BombSnapshot()
    }
    
    convenience init(bombSnapshot: BombSnapshot) {
        
        let bombTexture = CollectibleType.Bomb.getTexture()
        
        self.init(texture: bombTexture, color: .clear, size: bombTexture.size())
        self.initializePhysicsProperties(withTexture: bombTexture)
        self.name = CollectibleType.Bomb.getCollectibleName()
        self.collectibleType = CollectibleType.Bomb
        
        self.xScale *= 1.00
        self.yScale *= 1.00
    }
    
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
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
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
