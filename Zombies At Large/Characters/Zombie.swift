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
    
    private var shootInterval = 1.00
    private var attackInterval = 4.00
    private var followInterval = 2.00
    
    private var lastUpdateTime = 0.00
    private var frameCount = 0.00
    private var shootingFrameCount = 0.000
    
    private var isActive = false
    
    convenience init(zombieType: ZombieType, scale: CGFloat = 1.00) {
        
        
        let defaultTexture = zombieType.getDefaultTexture()
        
        self.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        configurePhysicsProperties(withTexture: defaultTexture, andWithSize: defaultTexture.size())
        
        self.zombieType = zombieType
        self.xScale *= scale
        self.yScale *= scale
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
        

        switch currentMode {
        case .Latent:
            break
        case .Attack:
            print("Zombie is currently in attack mode with framecount of \(frameCount)")
            self.frameCount += deltaTime
            self.shootingFrameCount += deltaTime

            if(frameCount > attackInterval){
                self.currentMode = .Following
                self.frameCount = 0.00
            }
            
            if(shootingFrameCount > shootInterval){
                fireBullet()
                shootingFrameCount = 0
            }
            
            
        case .Following:
            print("Zombie is currently in following mode with framecount of \(frameCount)")

            self.frameCount += deltaTime
            
            if(frameCount > followInterval){
                
                self.currentMode = .Attack
                
                self.frameCount = 0.00
            }
   
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
