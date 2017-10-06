//
//  RescueCharacter.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/17/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class RescueCharacter: SKSpriteNode{
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        
    }
    
    
    var player: Player!
    var nonPlayerCharacterType: NonplayerCharacterType!
    
    var hasBeenRescued = false
    
    var compassDirection: CompassDirection!{
        didSet{
            
            guard oldValue != compassDirection else { return }
            
            let rotation = ((compassDirection.zRotation - oldValue.zRotation) <= CGFloat.pi) && (compassDirection.zRotation > oldValue.zRotation)  ? (compassDirection.zRotation - oldValue.zRotation) : -(oldValue.zRotation - compassDirection.zRotation)
            
            
            run(SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.10))
            
            
        }
    }
    
    
    var constraintsForRescueCharacter: [SKConstraint]?{
        get{
            
            guard self.player != nil else {
                print("ERROR: the rescue character does not have a reference to the player")
                return nil
                
            }
            
            let lowerDistanceLimit = CGFloat(50.00)
            let upperDistanceLimit = CGFloat(150.0)
            
            let distanceRange = SKRange(lowerLimit: lowerDistanceLimit, upperLimit: upperDistanceLimit)
            let distanceConstraint = SKConstraint.distance(distanceRange, to: self.player!.position)
            
            let orientationRange = SKRange(lowerLimit: 0.00, upperLimit: 0.00)
            let orientationConstraint = SKConstraint.orient(to: self.player!.position, offset: orientationRange)
            
            return [distanceConstraint,orientationConstraint]
        }
    }
    
    convenience init(withPlayer player: Player, nonPlayerCharacterType: NonplayerCharacterType) {
      
        
        guard let texture = nonPlayerCharacterType.getTexture() else {
            fatalError("Error: Failed to located the texture for the nonPlayerCharacterType")
        }
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.RescueCharacter.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.RescueCharacter.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.RescueCharacter.contactMask
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 1.00
        self.physicsBody?.angularDamping = 0.00
        
        self.nonPlayerCharacterType = nonPlayerCharacterType
        self.compassDirection = .east
        self.player = player
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
    
    func rescueCharacter(){
        self.hasBeenRescued = true
    }
    
    func unrescueCharacter(){
        self.hasBeenRescued = false 
    }
    
    func constrainToPlayer(){
        if(self.hasBeenRescued){
            self.constraints = self.constraintsForRescueCharacter
        }
        
    }
 
}
