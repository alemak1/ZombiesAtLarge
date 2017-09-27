//
//  Player.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class Player: Shooter{
    
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
    
    var hasSpecialBullets = false
    
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
                bulletPB.collisionBitMask = ColliderType.SpecialBullets.collisionMask
                bulletPB.contactTestBitMask = ColliderType.SpecialBullets.contactMask
            }
            
        }
    }

    func activateSpecialBullets(){
        
        hasSpecialBullets = true
        
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
        
        self.numberOfBullets -= 1
        HUDManager.sharedManager.updateBulletCount(withUnits: self.numberOfBullets)
        
        
        print("Gun fired!")
        
    }
    
  
    
    
    
   
    
    public func playSoundForCollectibleContact(){
        run(self.playCollectItemSound)
    }
    
    public func hasItem(ofType collectibleType: CollectibleType) -> Bool{
        
        let collectible = Collectible(withCollectibleType: collectibleType)
        
        return self.collectibleManager.hasItem(collectible: collectible)
        
    }
}


