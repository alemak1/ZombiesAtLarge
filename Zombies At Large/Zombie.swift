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

class Zombie: SKSpriteNode{
    
    
    enum ZombieMode{
        case Latent
        case Following
        case Attack
    }
    
    private var zombieType: ZombieType!
    
    private var currentMode: ZombieMode = .Latent{
        didSet{
            guard oldValue != currentMode else { return }
            
            switch currentMode {
            case .Latent:
                run(SKAction.setTexture(zombieType.getDefaultTexture()))
            case .Following:
                self.frameCount = 0.00
                run(SKAction.setTexture(zombieType.getFollowTexture()))
            case .Attack:
                run(SKAction.setTexture(zombieType.getAttackTexture()))
      
            }
        }
    }
    
    let playFiringSound = SKAction.playSoundFileNamed("laser7", waitForCompletion: true)

    private var shootInterval = 3.00
    private var lastUpdateTime = 0.00
    private var frameCount = 0.00
    
    private var isActive = false
    
    convenience init(zombieType: ZombieType, scale: CGFloat = 1.00) {
        
        
        let defaultTexture = zombieType.getDefaultTexture()
        
        self.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        self.physicsBody = SKPhysicsBody(texture: defaultTexture, size: defaultTexture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 1.00
        physicsBody?.categoryBitMask = ColliderType.Zombie.rawValue
        physicsBody?.collisionBitMask = ColliderType.Player.rawValue | ColliderType.Wall.rawValue
        physicsBody?.contactTestBitMask = ColliderType.PlayerProximity.rawValue
        
        self.zombieType = zombieType
        self.xScale *= scale
        self.yScale *= scale
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func constrainTo(position: CGPoint, withLowerDistanceLimit lowerDistanceLimit: CGFloat = 0.00, andWithUpperDistanceLimit upperDistanceLimit: CGFloat = 500.0,andWithLowerOrientationLimit lowerOrientationLimit: CGFloat = 0.00, andWithUpperOrientationLimit upperOrientationLimit: CGFloat = 0.00){
        
        let distanceRange = SKRange(lowerLimit: lowerDistanceLimit, upperLimit: upperDistanceLimit)
        let distanceConstraint = SKConstraint.distance(distanceRange, to: position)
        
        let orientationRange = SKRange(lowerLimit: lowerOrientationLimit, upperLimit: upperOrientationLimit)
        let orientationConstraint = SKConstraint.orient(to: position, offset: orientationRange)
        
        self.constraints = [distanceConstraint,orientationConstraint]
        
        
    }
    
    func updateAnimations(withDeltaTime deltaTime: TimeInterval){
        

        switch currentMode {
        case .Latent:
            break
        case .Attack:
            break
        case .Following:
            
            self.frameCount += deltaTime
            
            print("Current frameCount for zombie is: \(self.frameCount)")
            
            if(frameCount > shootInterval){
                fireBullet()
                
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
    
    
    var appliedUnitVector: CGVector{
        get{
            
            let unitX = cos(zRotation)
            let unitY = sin(zRotation)
            
            return CGVector(dx: unitX, dy: unitY)
            
        }
    }
    
    public func fireBullet(){
        
        let zombieWidth = size.width
        let zombieHeight = size.height
        
        let bulletTexture = SKTexture(imageNamed: "bullet_fire1")
        let bullet = SKSpriteNode(texture: bulletTexture)
        
        bullet.physicsBody = SKPhysicsBody(texture: bulletTexture, size: bulletTexture.size())
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.linearDamping = 0.00
        
        bullet.position = CGPoint(x: zombieWidth*0.43, y: -zombieHeight*0.17)
        
        self.run(SKAction.run {
            self.addChild(bullet)
            
            self.run(SKAction.setTexture(self.zombieType.getShootTexture()))
            
            }, completion: {
                
                self.run(SKAction.sequence([
                    SKAction.run {
                        
                        let bulletMagnitude = CGFloat(10.00)
                        
                        let cgVector = CGVector(dx: bulletMagnitude*self.appliedUnitVector.dx, dy: bulletMagnitude*self.appliedUnitVector.dy)
                        
                        bullet.physicsBody?.applyImpulse(cgVector)
                        
                    },
                    SKAction.sequence([
                        SKAction.wait(forDuration: 1.0),
                        SKAction.run { bullet.removeFromParent() }
                        ])
                    ]))
        })
        
        
        
        let fireBullet = SKSpriteNode(imageNamed: "bullet_fire2")
        fireBullet.position = CGPoint(x: zombieWidth*0.43, y: -zombieHeight*0.17)
        
        
        self.run(SKAction.run {
            
            self.addChild(fireBullet)
            
            }, completion: {
                
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.10),
                    SKAction.run {
                        fireBullet.removeFromParent()
                    }
                    ]), completion: {
                        
                        self.run(SKAction.setTexture(self.zombieType.getShootTexture()))
                        self.run(self.playFiringSound)

                })
                
                
        })
        
        
        
        
        print("Gun fired by zombie!")
    }
    
    
}
