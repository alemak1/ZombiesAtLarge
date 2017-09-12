//
//  Tank.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


enum TankColor: String{
    case Red
    case Blue
    case Green
    case Beige
    case Black
    
    func getTankTexture() -> SKTexture{
        
        let textureName = "tank\(self.rawValue)"
        
        return SKTexture(imageNamed: textureName)
    }
    
    func getBarrelTexture() -> SKTexture{
        
        let textureName = "barrel\(self.rawValue)"
        
        return SKTexture(imageNamed: textureName)
    }
    
    
}


class Tank: SKSpriteNode{
    
    var barrelNode: BarrelNode!
    var tankColor: TankColor!
    var isEnemy: Bool!
   
    
  var appliedUnitVector: CGVector{
        
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
    
    convenience init(tankColor: TankColor, scale: CGFloat = 1.00, isEnemy: Bool = false) {
        
        let texture = tankColor.getTankTexture()
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(rectangleOf: texture.size())
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        
        self.isEnemy = isEnemy
        
        if(isEnemy){
            self.physicsBody?.categoryBitMask = ColliderType.Enemy.categoryMask
            self.physicsBody?.collisionBitMask = ColliderType.Enemy.collisionMask
            self.physicsBody?.contactTestBitMask = ColliderType.Enemy.contactMask
        } else {
            self.physicsBody?.categoryBitMask = ColliderType.Player.categoryMask
            self.physicsBody?.collisionBitMask = ColliderType.Player.collisionMask
            self.physicsBody?.contactTestBitMask = ColliderType.Player.contactMask
        }
     
        self.physicsBody?.linearDamping = 1.00
        self.physicsBody?.angularDamping = 1.00
        
        barrelNode = BarrelNode(tankColor: tankColor, isEnemy: isEnemy)
        addChild(barrelNode)
        
        self.tankColor = tankColor

        
    }
    
    public func rotateBarrel(byRotation zRotation: CGFloat){
        
        //TODO: correct the zRotation of the barrelNode
        
        print("The zRotation of the barrelnode is \(zRotation-compassDirection.zRotation)")
        
        barrelNode.compassDirection = CompassDirection(zRotation: zRotation-compassDirection.zRotation)
        
    }
    
    func applyMovementImpulse(withMagnitudeOf forceUnits: CGFloat){
        
        let dx = self.appliedUnitVector.dx*forceUnits
        let dy = self.appliedUnitVector.dy*forceUnits
        
        self.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        self.compassDirection = .east

        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.compassDirection = .north

        super.init(coder: aDecoder)
        
    }

    
    public func fireBullet(){
        
        self.barrelNode.fireBullet()
    }
    
}
