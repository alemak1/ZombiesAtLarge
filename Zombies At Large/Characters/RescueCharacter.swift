//
//  RescueCharacter.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/17/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class RescueCharacterSnapshot: NSCoding{
    
    
    var hasBeenRescued: Bool
    var compassDirectionRawValue: Int
    var nonplayerCharacterTypeRawValue: Int
    var physicsBody: SKPhysicsBody
    
    init(physicsBody: SKPhysicsBody, hasBeenRescued: Bool, compassDirectionRawValue: Int, nonplayerCharacterTypeRawValue: Int) {
        self.hasBeenRescued = hasBeenRescued
        self.compassDirectionRawValue = compassDirectionRawValue
        self.nonplayerCharacterTypeRawValue = nonplayerCharacterTypeRawValue
        self.physicsBody = physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hasBeenRescued = aDecoder.decodeBool(forKey: "hasBeenRescued")
        self.compassDirectionRawValue = aDecoder.decodeInteger(forKey: "compassDirectionRawValue")
        self.nonplayerCharacterTypeRawValue = aDecoder.decodeInteger(forKey: "nonplayerCharacterTypeRawValue")
        self.physicsBody = aDecoder.decodeObject(forKey: "physicsBody") as! SKPhysicsBody
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.hasBeenRescued, forKey: "hasBeenRescued")
        aCoder.encode(self.compassDirectionRawValue, forKey: "compassDirectionRawValue")
        aCoder.encode(self.nonplayerCharacterTypeRawValue, forKey: "nonplayerCharacterTypeRawValue")
        aCoder.encode(self.physicsBody, forKey: "physicsBody")
    }
}


class RescueCharacter: SKSpriteNode, Snapshottable{
    
    func getSnapshot() -> NSCoding {
        return RescueCharacterSnapshot(physicsBody: self.physicsBody!, hasBeenRescued: self.hasBeenRescued, compassDirectionRawValue: self.compassDirection.rawValue, nonplayerCharacterTypeRawValue: self.nonPlayerCharacterType.rawValue)
    }
    
    var snapshot: NSCoding{
        return RescueCharacterSnapshot(physicsBody: self.physicsBody!, hasBeenRescued: self.hasBeenRescued, compassDirectionRawValue: self.compassDirection.rawValue, nonplayerCharacterTypeRawValue: self.nonPlayerCharacterType.rawValue)

    }
    
    convenience init(rescueCharacterSnapshot: RescueCharacterSnapshot, player: Player) {
        
        let rawValue = rescueCharacterSnapshot.nonplayerCharacterTypeRawValue
        let nonPlayerCharacterType = NonplayerCharacterType(rawValue: rawValue)!
        
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
        
        let compassDirectionRawValue = rescueCharacterSnapshot.compassDirectionRawValue
        self.compassDirection = CompassDirection(rawValue: compassDirectionRawValue)!
        self.player = player
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
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
        print("Resucing character...")
        self.hasBeenRescued = true
        print("Character has been rescued...")

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
