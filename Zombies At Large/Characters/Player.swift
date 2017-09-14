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
    
    private var playerProximity: SKShapeNode!
    
    override var configureBulletBitmasks: ((inout SKPhysicsBody) -> Void)?{
        
        return {(bulletPB: inout SKPhysicsBody) in
            
            bulletPB.categoryBitMask = ColliderType.PlayerBullets.categoryMask
            bulletPB.collisionBitMask = ColliderType.PlayerBullets.collisionMask
            bulletPB.contactTestBitMask = ColliderType.PlayerBullets.contactMask
            
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
    
    convenience init(playerType: PlayerType){
        
        let playerTexture = playerType.getTexture(textureType: .gun)
        
        self.init(texture: playerTexture, color: .clear, size: playerTexture.size())
        
        
        playerProximity = SKShapeNode(circleOfRadius: 50.0)
        addChild(playerProximity)
        
        playerProximity.position = self.position
        playerProximity.name = "playerProximity"
        
    
        let playerProximityPB = SKPhysicsBody(circleOfRadius: 50.0)
        playerProximityPB.affectedByGravity = false
        playerProximityPB.linearDamping = 0.00
        playerProximityPB.isDynamic = false
        playerProximityPB.allowsRotation = false
        playerProximityPB.categoryBitMask = ColliderType.PlayerProximity.categoryMask
        playerProximityPB.collisionBitMask = ColliderType.PlayerProximity.collisionMask
        playerProximityPB.contactTestBitMask = ColliderType.PlayerProximity.contactMask
        playerProximity.physicsBody = playerProximityPB
        
        let joint = SKPhysicsJointFixed()
        joint.bodyA = physicsBody!
        joint.bodyB = playerProximity.physicsBody!
        
       
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
    
    public func fireBullet(){
        
        super.fireBullet(withPrefireHandler: {}, andWithPostfireHandler: {})
        
        print("Gun fired!")
        
    }
    
  
    
    
    
    /** Updates the player proximity node so that it is aligned with player's current position; player proximity node is used to check for nearby zombies; adding it as a child node results in slower performance **/
    
    public func updatePlayerProximity(){
        self.playerProximity.position = position
       
    }
    
    
    /** Helper function that provides access to the player proximity node, which is used by the zombie manager to detect presence of zombies in close proximity to the player **/
    
    public func getPlayerProximityNode() -> SKShapeNode{
        
        return playerProximity
        
    }
    
    //public func checkProximityOf(anotherPoint point: CGPoint) -> Bool{
     //   return playerProximity.contains(point)
   // }
    
    public func playSoundForCollectibleContact(){
        run(self.playCollectItemSound)
    }
    
    public func hasItem(ofType collectibleType: CollectibleType) -> Bool{
        
        let collectible = Collectible(withCollectibleType: collectibleType)
        
        return self.collectibleManager.hasItem(collectible: collectible)
        
    }
}


