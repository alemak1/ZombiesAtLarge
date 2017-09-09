//
//  Player.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class Player: SKSpriteNode{
    
    private var playerType: PlayerType
    
    private var playerProximity: SKSpriteNode!
    
    private var bulletInTransit = false
    
    let playFiringSound = SKAction.playSoundFileNamed("laser1", waitForCompletion: true)
    
    var appliedUnitVector: CGVector{
        
        let xUnitVector = cos(compassDirection.zRotation)
        let yUnitVector = sin(compassDirection.zRotation)
        
        return CGVector(dx: xUnitVector, dy: yUnitVector)
    }
    
    var compassDirection: CompassDirection{
        didSet{
            
            guard oldValue != compassDirection else { return }
            
            let rotation = ((compassDirection.zRotation - oldValue.zRotation) <= CGFloat.pi) && (compassDirection.zRotation > oldValue.zRotation)  ? (compassDirection.zRotation - oldValue.zRotation) : -(oldValue.zRotation - compassDirection.zRotation)
            
            print("Old zRotation is \(oldValue)")
            print("New zRotation is \(zRotation)")
            
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
    
 
    
    convenience init(playerType: PlayerType, scale: CGFloat){
        self.init(playerType: playerType)
        
        self.xScale *= scale
        self.yScale *= scale
        
        
    }
    
    convenience init(playerType: PlayerType){
        
        let playerTexture = playerType.getTexture(textureType: .gun)
        
        self.init(texture: playerTexture, color: .clear, size: playerTexture.size())
        
        let proximitySize = CGSize(width: self.size.width*5, height: self.size.height*5)
        
        playerProximity = SKSpriteNode(texture: nil, color:.clear, size: proximitySize)
        
        playerProximity.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playerProximity.position = self.position
        playerProximity.name = "playerProximity"
        playerProximity.physicsBody = SKPhysicsBody(circleOfRadius: 5*proximitySize.width)
        playerProximity.physicsBody?.categoryBitMask = ColliderType.PlayerProximity.rawValue
        playerProximity.physicsBody?.collisionBitMask = 00
        playerProximity.physicsBody?.contactTestBitMask = ColliderType.Zombie.rawValue
        
    
       
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let defaultPlayerType = PlayerType(rawValue: "manBlue")!
        
        self.playerType = defaultPlayerType
        self.compassDirection = .east
        
        let texture = texture ?? defaultPlayerType.getTexture(textureType: .gun)
        
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.Player.rawValue
        self.physicsBody?.collisionBitMask = ColliderType.Wall.rawValue | ColliderType.ZombieBullet.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.ZombieBullet.rawValue
        
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
    
    
    public func fireBullet(){
        
        guard !bulletInTransit else { return }
        
        let bullet = getBullet()
        let gunfire = getGunfire()
        
        let bulletMagnitude = CGFloat(10.00)
        
        let cgVector = CGVector(dx: bulletMagnitude*self.appliedUnitVector.dx, dy: bulletMagnitude*self.appliedUnitVector.dy)
        
        
        self.run(SKAction.sequence([
            SKAction.run {
                
                self.bulletInTransit = true
                
                self.addChild(bullet)
                self.addChild(gunfire)
                
                bullet.physicsBody?.applyImpulse(cgVector)


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
            }

            ]))
                print("Gun fired!")
    }
    
    /** Helper function to generate gunfire **/
    
    private func getGunfire() -> SKSpriteNode{
        
        let playerWidth = size.width
        let playerHeight = size.height
        
        let gunfire = SKSpriteNode(imageNamed: "bullet_fire2")
        gunfire.position = CGPoint(x: playerWidth*0.43, y: -playerHeight*0.17)
        
        return gunfire
    }
    
    /** Helper function to generate fired bullets **/
    
    private func getBullet() -> SKSpriteNode{
        
        let playerWidth = size.width
        let playerHeight = size.height
        

        let bulletTexture = SKTexture(imageNamed: "bullet_fire1")
        let bullet = SKSpriteNode(texture: bulletTexture)
        
        bullet.physicsBody = SKPhysicsBody(texture: bulletTexture, size: bulletTexture.size())
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.allowsRotation = false
        bullet.physicsBody?.linearDamping = 0.50
        bullet.physicsBody?.categoryBitMask = ColliderType.PlayerBullet.rawValue
        bullet.physicsBody?.collisionBitMask = ColliderType.Zombie.rawValue
        bullet.physicsBody?.contactTestBitMask = ColliderType.Zombie.rawValue
        
        bullet.position = CGPoint(x: playerWidth*0.43, y: -playerHeight*0.17)
        
        return bullet
    }
    
    /** Updates the player proximity node so that it is aligned with player's current position; player proximity node is used to check for nearby zombies; adding it as a child node results in slower performance **/
    
    public func updatePlayerProximity(){
        self.playerProximity.position = position
       
    }
    
    
    /** Helper function that provides access to the player proximity node, which is used by the zombie manager to detect presence of zombies in close proximity to the player **/
    
    public func getPlayerProximityNode() -> SKSpriteNode{
        
        return playerProximity
        
    }
    
    public func checkProximityOf(anotherPoint point: CGPoint) -> Bool{
        return playerProximity.contains(point)
    }
    
}


