//
//  Zombie.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/9/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class ZombieSnapshot: NSObject, NSCoding, Saveable{
    
    var currentHealth: Int
    var isDamaged: Bool
    var zombieTypeRawValue: String
    var physicsBody: SKPhysicsBody
    var zombieModeRawValue: Int
    
    init(zombieModeRawValue: Int, currentHealth: Int, isDamaged: Bool, zombieTypeRawValue: String, physicsBody: SKPhysicsBody){
        self.currentHealth = currentHealth
        self.isDamaged = isDamaged
        self.zombieTypeRawValue = zombieTypeRawValue
        self.physicsBody = physicsBody
        self.zombieModeRawValue = zombieModeRawValue
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.currentHealth = aDecoder.decodeInteger(forKey: "currentHealth")
        self.isDamaged = aDecoder.decodeBool(forKey: "isDamaged")
        self.zombieTypeRawValue = aDecoder.decodeObject(forKey: "zombieTypeRawValue") as! String
        self.physicsBody = aDecoder.decodeObject(forKey: "physicsBody") as! SKPhysicsBody
        self.zombieModeRawValue = aDecoder.decodeInteger(forKey: "zombieModeRawValue")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.isDamaged, forKey: "isDamaged")
        aCoder.encode(self.currentHealth, forKey: "currentHealth")
        aCoder.encode(self.zombieTypeRawValue, forKey: "zombieTypeRawValue")
        aCoder.encode(self.physicsBody, forKey: "physicsBody")
        aCoder.encode(self.zombieModeRawValue, forKey: "zombieModeRawValue")

        
    }
    

}

enum ZombieType: String{
    case zombie1
    case zombie2
    
    
    func getDefaultTexture() -> SKTexture{
    
        let baseStr = self.rawValue
        let finalStr = baseStr.appending("_stand")
        
        return SKTexture(imageNamed: finalStr)
        
    }
    
    
    func getFollowTexture() -> SKTexture{
        
        let baseStr = self.rawValue
        let finalStr = baseStr.appending("_hold")
        
        return SKTexture(imageNamed: finalStr)
    }
    
    
    func getAttackTexture() -> SKTexture{
        let baseStr = self.rawValue
    
        let finalStr = baseStr.appending("_reload")
        
        return SKTexture(imageNamed: finalStr)
        
    }

    func getShootTexture() -> SKTexture{
        
        let baseStr = self.rawValue
        let finalStr = baseStr.appending("_gun")
        return SKTexture(imageNamed: finalStr)
    }
}

class Zombie: Shooter,Snapshottable{
    
    func getSnapshot() -> Saveable {
        
        let zombieModeRawValue = self.currentMode.rawValue
        let zombieTypeRawValue = self.zombieType.rawValue
        
        return ZombieSnapshot(zombieModeRawValue: zombieModeRawValue, currentHealth: self.currentHealth, isDamaged: self.isDamaged, zombieTypeRawValue: zombieTypeRawValue, physicsBody: self.physicsBody!)
    }
    
    
    var snapshot: Saveable{
        
        let zombieModeRawValue = self.currentMode.rawValue
        let zombieTypeRawValue = self.zombieType.rawValue
        
        return ZombieSnapshot(zombieModeRawValue: zombieModeRawValue, currentHealth: self.currentHealth, isDamaged: self.isDamaged, zombieTypeRawValue: zombieTypeRawValue, physicsBody: self.physicsBody!)

    }
    
    enum ZombieMode: Int{
        case Latent = 0
        case Following
        case Attack
    }
    
     var zombieType: ZombieType!
    
     var currentHealth: Int = 3
     var isDamaged: Bool = false
    
    /** Helper initializer to allow zombies to be initialized from ZombieSnapShot **/
    
    convenience init(withZombieSnapshot zombieSnapshot: ZombieSnapshot){

        let zombieType = ZombieType(rawValue: zombieSnapshot.zombieTypeRawValue)!
        let defaultTexture = zombieType.getDefaultTexture()
        
        self.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())

        self.currentMode = ZombieMode(rawValue: zombieSnapshot.zombieModeRawValue)!

        configurePhysicsProperties(withTexture: defaultTexture, andWithSize: defaultTexture.size())
        
        self.zombieType = zombieType
        self.currentHealth = zombieSnapshot.currentHealth
        self.xScale *= 1.50
        self.yScale *= 1.50
        
        self.attackInterval = Double(arc4random_uniform(UInt32(3.00))) + 3.00
        self.followInterval = Double(arc4random_uniform(UInt32(5.00)))
        self.shootInterval = Double(arc4random_uniform(UInt32(2.0))) + 1.0
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let zombieTypeRawValue = aDecoder.decodeObject(forKey: "zombieTypeRawValue") as! String
        self.zombieType = ZombieType(rawValue: zombieTypeRawValue)
        self.isDamaged = aDecoder.decodeBool(forKey: "isDamaged")
        self.currentHealth = aDecoder.decodeInteger(forKey: "currentHealth")
        self.physicsBody = aDecoder.decodeObject(forKey: "physicsBody") as? SKPhysicsBody
        
        let zombieModeRawValue = aDecoder.decodeInteger(forKey: "currentMode")
        self.currentMode = ZombieMode(rawValue: zombieModeRawValue)!
    
    
    
   
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(zombieType.rawValue, forKey: "zombieTypeRawValue")
        aCoder.encode(isDamaged, forKey: "isDamaged")
        aCoder.encode(currentHealth, forKey: "currentHealth")
        aCoder.encode(self.physicsBody, forKey: "physicsBody")
        aCoder.encode(self.currentMode.rawValue, forKey: "currentMode")
        aCoder.encode(self.isActive, forKey: "isActive")
        
        /**
        aCoder.encode(self.position, forKey: "position")
        aCoder.encode(zPosition, forKey: "zPosition")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.physicsBody, forKey: "physicsBody")
         **/
        
        
    }
  
    
    override var configureBulletBitmasks: ((inout SKPhysicsBody) -> Void)?{
        
        return {(bulletPB: inout SKPhysicsBody) in
            
            bulletPB.categoryBitMask = ColliderType.EnemyBullets.categoryMask
            bulletPB.collisionBitMask = ColliderType.EnemyBullets.collisionMask
            bulletPB.contactTestBitMask = ColliderType.EnemyBullets.contactMask
            
        }
    }
    
    var currentMode: ZombieMode = .Latent{
        didSet{
            guard oldValue != currentMode else { return }
            
            switch currentMode {
            case .Latent:
                self.frameCount = 0.00
                run(SKAction.setTexture(zombieType.getDefaultTexture()))
            case .Following:
                self.frameCount = 0.00
                run(SKAction.setTexture(zombieType.getFollowTexture()))
            case .Attack:
                self.shootingFrameCount = 0.00
                self.frameCount = 0.00
                run(SKAction.setTexture(zombieType.getAttackTexture()))
      
            }
        }
    }
    
    
    override var playFiringSound: SKAction
        {
        return SKAction.playSoundFileNamed("laser7", waitForCompletion: true)
    }

    /** Timer Related Variables: Zombie will be in attack mode for a period of time designated as attackInterval; During the attack interval, it will fire bullets at every shoot interval **/
    
     var shootInterval = 2.00
    
     var attackInterval: Double = 4.00
     var followInterval: Double = 4.00
    
     var lastUpdateTime = 0.00
     var lastUpdatedShootingTime = 0.00
     var frameCount = 0.00
     var shootingFrameCount = 0.000
    
    private var isActive = false
    
    convenience init(zombieType: ZombieType, scale: CGFloat = 1.00, startingHealth: Int = 3) {
        
        
        let defaultTexture = zombieType.getDefaultTexture()
        
        self.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        configurePhysicsProperties(withTexture: defaultTexture, andWithSize: defaultTexture.size())
        
        self.zombieType = zombieType
        self.currentHealth = startingHealth
        self.xScale *= scale
        self.yScale *= scale
        
        self.attackInterval = Double(arc4random_uniform(UInt32(3.00))) + 3.00
        self.followInterval = Double(arc4random_uniform(UInt32(5.00)))
        self.shootInterval = Double(arc4random_uniform(UInt32(2.0))) + 1.0
    }
    
    /** Helper function for configuring physics properties during initializaiton  **/
    
    func configurePhysicsProperties(withTexture texture: SKTexture, andWithSize size: CGSize){
       
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 1.00
        physicsBody?.categoryBitMask = ColliderType.Enemy.categoryMask
        physicsBody?.collisionBitMask = ColliderType.Enemy.collisionMask
        physicsBody?.contactTestBitMask = ColliderType.Enemy.contactMask
        
    }
  
    func constrainTo(position: CGPoint, withLowerDistanceLimit lowerDistanceLimit: CGFloat = 0.00, andWithUpperDistanceLimit upperDistanceLimit: CGFloat = 500.0,andWithLowerOrientationLimit lowerOrientationLimit: CGFloat = 0.00, andWithUpperOrientationLimit upperOrientationLimit: CGFloat = 0.00){
        
        let distanceRange = SKRange(lowerLimit: lowerDistanceLimit, upperLimit: upperDistanceLimit)
        let distanceConstraint = SKConstraint.distance(distanceRange, to: position)
        
        let orientationRange = SKRange(lowerLimit: lowerOrientationLimit, upperLimit: upperOrientationLimit)
        let orientationConstraint = SKConstraint.orient(to: position, offset: orientationRange)
        
        self.constraints = [distanceConstraint,orientationConstraint]
        
        
    }
    
    func constrainOrientation(toPosition position: CGPoint, andWithLowerOrientationLimit lowerOrientationLimit: CGFloat = 0.00, andWithUpperOrientationLimit upperOrientationLimit: CGFloat = 0.00){
        
        let orientationRange = SKRange(lowerLimit: lowerOrientationLimit, upperLimit: upperOrientationLimit)
        let orientationConstraint = SKConstraint.orient(to: position, offset: orientationRange)
        
        self.constraints = [orientationConstraint]
        
        
    }
    
    func updateAnimations(withDeltaTime deltaTime: TimeInterval){
        
        if(lastUpdateTime == 0){
            lastUpdateTime = deltaTime;
        }
        self.frameCount += deltaTime - lastUpdateTime

        switch currentMode {
        case .Latent:
            break
        case .Attack:
           
         
            self.shootingFrameCount += frameCount - lastUpdatedShootingTime

            if(frameCount > attackInterval){
                self.currentMode = .Following
                self.frameCount = 0.00
            }
            
            if(shootingFrameCount > shootInterval){
                fireBullet()
                shootingFrameCount = 0
            }
            
            lastUpdatedShootingTime = frameCount
            
        case .Following:

          
          
            if(frameCount > followInterval){
                
                self.currentMode = .Attack
                
                self.frameCount = 0.00
            }
            
   
        }
        
        lastUpdateTime = deltaTime

        
    }
   
    
    func takeHit(){
        
        switch self.currentHealth {
        case 3:
            takeDamage1()
            break
        case 2:
            takeDamage2()
            break
        case 1:
            takeDamage3()
            break
        case 0:
            die()
            break
        default:
            takeDamage()
            print("No logic implemented for health of \(self.currentHealth)")
        }
    }
    
    
    private func takeDamage(){
        if(!isDamaged){
            isDamaged = true
            
            run(SKAction.run {
                
                self.run(SKAction.colorize(with: SKColor.red, colorBlendFactor: 0.10, duration: 0.20))
                self.currentHealth -= 1
                }, completion: {
                    
                    self.isDamaged = false
                    
            })
            
        }
    }
    
    
    private func takeDamage1(){
        if(!isDamaged){
            isDamaged = true
            
            run(SKAction.run {
                
                self.run(SKAction.colorize(with: SKColor.red, colorBlendFactor: 0.50, duration: 0.20))
                self.currentHealth -= 1
                }, completion: {
                    
                    self.isDamaged = false
                    
            })
            
        }
    }
    
    
    private func takeDamage2(){
        if(!isDamaged){
            isDamaged = true
            
            run(SKAction.run {
                
                self.run(SKAction.fadeAlpha(to: 0.60, duration: 0.30))
                self.currentHealth -= 1
                }, completion: {
                    
                    self.isDamaged = false
                    
            })
            
        }

    }
    
    
    private func takeDamage3(){
        
        if(!isDamaged){
            isDamaged = true
            
            run(SKAction.run {
                
                self.run(SKAction.fadeAlpha(to: 0.30, duration: 0.30))
                self.currentHealth -= 1
                }, completion: {
                    
                    self.isDamaged = false
                    
            })
            
        }

    }
    
    func die(completion: (() -> Void)? = nil){
    
    
        if(!isDamaged){
            isDamaged = true
    
            run(SKAction.animate(with: [
                SKTexture(image: #imageLiteral(resourceName: "regularExplosion01")),
                SKTexture(image: #imageLiteral(resourceName: "regularExplosion02")),
                SKTexture(image: #imageLiteral(resourceName: "regularExplosion03")),
                SKTexture(image: #imageLiteral(resourceName: "regularExplosion04")),
                SKTexture(image: #imageLiteral(resourceName: "regularExplosion05")),
                SKTexture(image: #imageLiteral(resourceName: "regularExplosion06")),
                SKTexture(image: #imageLiteral(resourceName: "regularExplosion08")),
                ], timePerFrame: 0.10), completion: {
                
                    self.removeFromParent()
                
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "didKillZombieNotification"), object: nil)
                    
                    if completion != nil{
                        completion!()

                    }
            })
        }
    }
    
    func hasBeenActivated() -> Bool{
        return isActive
    }
    
    func activateZombie(){
        
        currentMode = .Following
        isActive = true
        
    }
    
    
    override var appliedUnitVector: CGVector{
        get{
            
            let unitX = cos(zRotation)
            let unitY = sin(zRotation)
            
            return CGVector(dx: unitX, dy: unitY)
            
        }
    }
    
    

    
    public func fireBullet(){
        
        super.fireBullet(withPrefireHandler: {
            
            self.run(SKAction.setTexture(self.zombieType.getShootTexture()))
            
        }, andWithPostfireHandler: {
            
            self.run(SKAction.setTexture(self.zombieType.getAttackTexture()))
        })
        
    }
    

    
    
    
    /**
    override func getBullet() -> SKSpriteNode{
        
        let bullet = super.getBullet()
        
    
        bullet.physicsBody?.categoryBitMask = ColliderType.ZombieBullet.rawValue
        bullet.physicsBody?.collisionBitMask = ColliderType.Player.rawValue
        bullet.physicsBody?.contactTestBitMask = ColliderType.Player.rawValue
 
        
        return bullet
    }
     **/
    
    
    //MARK: ********* Designated and required initializers
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
   
}
