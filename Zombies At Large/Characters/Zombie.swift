//
//  Zombie.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/9/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


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

class Zombie: Shooter{
    
    
    enum ZombieMode{
        case Latent
        case Following
        case Attack
    }
    
    private var zombieType: ZombieType!
    
    private var currentHealth: Int = 3
    private var isDamaged: Bool = false
    
    override var configureBulletBitmasks: ((inout SKPhysicsBody) -> Void)?{
        
        return {(bulletPB: inout SKPhysicsBody) in
            
            bulletPB.categoryBitMask = ColliderType.EnemyBullets.categoryMask
            bulletPB.collisionBitMask = ColliderType.EnemyBullets.collisionMask
            bulletPB.contactTestBitMask = ColliderType.EnemyBullets.contactMask
            
        }
    }
    
    private var currentMode: ZombieMode = .Latent{
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
    
    private var shootInterval = 2.00
    
    private var attackInterval: Double = 4.00
    private var followInterval: Double = 4.00
    
    private var lastUpdateTime = 0.00
    private var lastUpdatedShootingTime = 0.00
    private var frameCount = 0.00
    private var shootingFrameCount = 0.000
    
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
    
    private func configurePhysicsProperties(withTexture texture: SKTexture, andWithSize size: CGSize){
       
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
            print("No logic implemented for health of \(self.currentHealth)")
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
    
    private func die(){
        
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
        })
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
