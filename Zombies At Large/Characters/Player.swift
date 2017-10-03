//
//  Player.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class PlayerStateSnapShot: NSObject, NSCoding{
    
    var healthLevel: Int
    var numberOfBullets: Int
    var compassOrientation: CompassDirection
    var position: CGPoint
    var currentVelocity: CGVector
    var playerType: PlayerType
    var collectibleManager: CollectibleManager
    
    init(playerType: PlayerType, healthLevel: Int, numberOfBullets: Int, compassOrientation: CompassDirection, position: CGPoint, currentVelocity: CGVector, collectibleManager: CollectibleManager) {
        
        self.playerType = playerType
        self.healthLevel = healthLevel
        self.numberOfBullets = numberOfBullets
        self.compassOrientation = compassOrientation
        self.position = position
        self.currentVelocity = currentVelocity
        self.collectibleManager = collectibleManager
        
        super.init()
        
    }
    

    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.position, forKey: "position")
        aCoder.encode(self.currentVelocity, forKey: "currentVelocity")
        aCoder.encode(self.healthLevel, forKey: "healthLevel")
        aCoder.encode(self.numberOfBullets, forKey: "numberOfBullets")
        
       aCoder.encode(self.playerType.getIntegerValue(), forKey: "playerType")
       aCoder.encode(Int64(self.compassOrientation.rawValue), forKey: "compassDirection")
       aCoder.encode(self.collectibleManager, forKey: "collectibleManager")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.position = aDecoder.decodeCGPoint(forKey: "position")
        self.currentVelocity = aDecoder.decodeCGVector(forKey: "currentVelocity")
        self.healthLevel = aDecoder.decodeInteger(forKey: "healthLevel")
        self.numberOfBullets = aDecoder.decodeInteger(forKey: "numberOfBullets")
        
    
        
        self.compassOrientation = CompassDirection(rawValue: Int(aDecoder.decodeInt64(forKey: "compassDirection"))) ?? .east
        
        let playerInt = (aDecoder.decodeObject(forKey: "playerType") as? Int) ?? 1
        self.playerType = PlayerType(withIntegerValue: playerInt)
        
        self.collectibleManager = (aDecoder.decodeObject(forKey: "collectibleManager") as? CollectibleManager) ?? CollectibleManager()
        
    
    }
}

class Player: Shooter{
    
    
    var pickedImage: UIImage?{
        didSet{
            if(pickedImage != nil){
                //post a notification that is sent to the NPC
            }
        }
    }
    
    lazy var playerStateSnapShot: PlayerStateSnapShot = {
        
        let velocity = self.physicsBody?.velocity ?? CGVector.zero
        
        return PlayerStateSnapShot(playerType: self.playerType, healthLevel: self.health, numberOfBullets: self.numberOfBullets, compassOrientation: self.compassDirection, position: self.position, currentVelocity: velocity, collectibleManager: self.collectibleManager)
        
    }()
    
    func configurePlayerState(withPlayerStateSnapshot playerStateSnapshot: PlayerStateSnapShot){
        
        self.position = playerStateSnapshot.position
        self.playerType = playerStateSnapshot.playerType
        self.compassDirection = playerStateSnapshot.compassOrientation
        self.health = playerStateSnapshot.healthLevel
        self.numberOfBullets = playerStateSnapshot.numberOfBullets
        self.physicsBody?.velocity = playerStateSnapshot.currentVelocity
        
    }
    
    private var playerType: PlayerType
    
    
    private var health: Int = 15{
        didSet{
            if self.health < 0{
                let playerDiedNotification = Notification.Name(rawValue: "playerDiedNotification")
                NotificationCenter.default.post(name: playerDiedNotification, object: nil)
            }
        }
    }
    
    private var numberOfBullets: Int = 30
    
    private var numberOfBulletsFired: Int = 0
    
    var hasSpecialBullets: Bool{
        
        return self.collectibleManager.getActiveStatusFor(collectibleType: .SilverBullet)
        
    }
    
    var updatingBulletCount = false
    var isTemporarilyInvulnerable = false
    
    override var configureBulletBitmasks: ((inout SKPhysicsBody) -> Void)?{
        
        return {(bulletPB: inout SKPhysicsBody) in
            
            if(!self.hasSpecialBullets){
                bulletPB.categoryBitMask = ColliderType.PlayerBullets.categoryMask
                bulletPB.collisionBitMask = ColliderType.PlayerBullets.collisionMask
                bulletPB.contactTestBitMask = ColliderType.PlayerBullets.contactMask
                
            } else {
                
                bulletPB.categoryBitMask = ColliderType.SpecialBullets.categoryMask
                bulletPB.collisionBitMask = ColliderType.SpecialBullets.collisionMask | ~ColliderType.Obstacle.categoryMask
                bulletPB.contactTestBitMask = ColliderType.SpecialBullets.contactMask
            }
            
        }
    }

  
    
    override var playFiringSound: SKAction
    {
        return SKAction.playSoundFileNamed("laser1", waitForCompletion: true)
    }
    
    var playCollectItemSound: SKAction{
        return SKAction.playSoundFileNamed("coin5", waitForCompletion: false)
    }
    
    override var appliedUnitVector: CGVector{
    
        let xUnitVector = cos(compassDirection.zRotation)
        let yUnitVector = sin(compassDirection.zRotation)
        
        return CGVector(dx: xUnitVector, dy: yUnitVector)
    }
    
    var compassDirection: CompassDirection{
        didSet{
            
            guard oldValue != compassDirection else { return }
            
            let rotation = ((compassDirection.zRotation - oldValue.zRotation) <= CGFloat.pi) && (compassDirection.zRotation > oldValue.zRotation)  ? (compassDirection.zRotation - oldValue.zRotation) : -(oldValue.zRotation - compassDirection.zRotation)
            
       
            run(SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.10))
            

            }
        }
    
    public func getCurrentHealth() -> Int{
        return self.health
    }
    
    public func getCurrentNumberOfBullets() -> Int{
        return self.numberOfBullets
    }
    
    
    /**
    var currentOrientation: Orientation{
        didSet{
            
            guard oldValue != currentOrientation else { return }
            
            print("The player orientation has changed")
            
            var newRotationAngle: Double
            
            switch currentOrientation {
            case .down:
                print("The player orientation has changed to down")
                newRotationAngle = oldValue == .left  ?  Double.pi*3/2 : -Double.pi/2
                break
            case .up:
                print("The player orientation has changed to up")
                newRotationAngle = Double.pi/2
                break
            case .left:
                print("The player orientation has changed to left")
                newRotationAngle = oldValue == .down ? -Double.pi : Double.pi
                break
            case .right:
                print("The player orientation has changed to right")
                newRotationAngle = 0.00
                break
            }
            
            run(SKAction.rotate(toAngle: CGFloat(newRotationAngle), duration: 0.10))
        }
     
     }
 **/
    
 
    var collectibleManager = CollectibleManager()
    
    convenience init(playerType: PlayerType, scale: CGFloat){
        self.init(playerType: playerType)
        
        self.xScale *= scale
        self.yScale *= scale
        
        
    }
    
    convenience init(playerType: PlayerType,startingHealth: Int = 15, numberOfBullets: Int = 30){
        
        let playerTexture = playerType.getTexture(textureType: .gun)
        
        self.init(texture: playerTexture, color: .clear, size: playerTexture.size())
        
        self.numberOfBullets = numberOfBullets
        self.health = startingHealth
        
        
    }
    
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let defaultPlayerType = PlayerType(rawValue: "manBlue")!
        
        self.playerType = defaultPlayerType
        self.compassDirection = .east
        
        let texture = texture ?? defaultPlayerType.getTexture(textureType: .gun)
        
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.Player.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.Player.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.Player.contactMask
        self.physicsBody?.fieldBitMask = ColliderType.RepulsionField.categoryMask
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 1.00
        self.physicsBody?.angularDamping = 0.00
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
   
    
    func applyMovementImpulse(withMagnitudeOf forceUnits: CGFloat){
        
        let dx = self.appliedUnitVector.dx*forceUnits
        let dy = self.appliedUnitVector.dy*forceUnits
        
        self.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }
    
    
    public func addCollectibleItem(newCollectible: Collectible, completionHandler:(() -> Void)? = nil){
        
        collectibleManager.addCollectibleItem(newCollectible: newCollectible, andWithQuantityOf: 1)
    
        if completionHandler != nil{
            completionHandler!()
        }
        
    }
    
    public func showCollectibleManagerDescription(){
        
        collectibleManager.showDescriptionForCollectibleManager()
        
    }
    
    public func increaseHealth(byHealthUnits healthUnits: Int){
        print("Increasing player health...")

        if(self.health + healthUnits > 15){
            self.health = 15
        } else {
            self.health += healthUnits
        }
        
        HUDManager.sharedManager.updateHealthCount(withUnits: self.health)
    }
    
    public func takeDamage(){
    
        if(isTemporarilyInvulnerable) {
            return
            
        } else
        {
            self.isTemporarilyInvulnerable = true

        }
        

        run(SKAction.sequence([
            SKAction.run {
                print("Player has taken damage...")
                self.health -= 1
                HUDManager.sharedManager.updateHealthCount(withUnits: self.health)
                
            },
            SKAction.wait(forDuration: 0.20)
            ]), completion: {
            
            self.isTemporarilyInvulnerable = false
        })
        
    }
    
    public func increaseBullets(byBullets bullets: Int){
        print("Bullets have increased by \(bullets)")
        
        if(self.numberOfBullets + bullets > 30){
            self.numberOfBullets = 30
        } else {
            self.numberOfBullets += bullets
        }
        HUDManager.sharedManager.updateBulletCount(withUnits: self.numberOfBullets)

    }
    
    public func fireBullet(){
        
        if(self.numberOfBullets <= 0) { return }
        
        super.fireBullet(withPrefireHandler: {}, andWithPostfireHandler: {})
        
        self.numberOfBulletsFired += 1
        self.numberOfBullets -= 1
        HUDManager.sharedManager.updateBulletCount(withUnits: self.numberOfBullets)
        
        
        print("Gun fired!")
        
    }
    
    public func getNumberOfBulletsFired() -> Int{
        return self.numberOfBulletsFired
    }
    
    
    public func playSoundForCollectibleContact(){
        run(self.playCollectItemSound)
    }
    
    public func hasItem(ofType collectibleType: CollectibleType) -> Bool{
        
        let collectible = Collectible(withCollectibleType: collectibleType)
        
        return self.collectibleManager.hasItem(collectible: collectible)
        
    }
    

}


