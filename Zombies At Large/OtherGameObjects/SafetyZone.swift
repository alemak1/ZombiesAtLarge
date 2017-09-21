//
//  SafetyZone.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/17/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class SafetyZone: SKSpriteNode{
    
    enum SafetyZoneType{
        case Red, Yellow, Blue, Green
        
        func getTexture() -> SKTexture{
            switch self {
            case .Red:
                return SKTexture(image: #imageLiteral(resourceName: "flagRed1"))
            case .Blue:
                return SKTexture(image: #imageLiteral(resourceName: "flagBlue1"))
            case .Green:
                return SKTexture(image: #imageLiteral(resourceName: "flagGreen1"))
            case .Yellow:
                return SKTexture(image: #imageLiteral(resourceName: "flagYellow1"))
                
            }
        }
        
        func getAnimation() -> SKAction{
            switch self {
            case .Green:
                return SKAction.animate(with: [
                    SKTexture(image: #imageLiteral(resourceName: "flagGreen1")),
                    SKTexture(image: #imageLiteral(resourceName: "flagGreen2"))
                    ], timePerFrame: 0.10)
            case .Red:
                return SKAction.animate(with: [
                    SKTexture(image: #imageLiteral(resourceName: "flagRed1")),
                    SKTexture(image: #imageLiteral(resourceName: "flagRed2"))
                    ], timePerFrame: 0.10)
            case .Yellow:
                return SKAction.animate(with: [
                    SKTexture(image: #imageLiteral(resourceName: "flagYellow1")),
                    SKTexture(image: #imageLiteral(resourceName: "flagYellow2"))
                    ], timePerFrame: 0.10)
            case .Blue:
                return SKAction.animate(with: [
                    SKTexture(image: #imageLiteral(resourceName: "flagBlue1")),
                    SKTexture(image: #imageLiteral(resourceName: "flagBlue2"))
                    ], timePerFrame: 0.10)
            }
        }
    }
    
    var safetyZoneType: SafetyZoneType!
    
    convenience init(safetyZoneType: SafetyZoneType, scale: CGFloat) {
        
        let texture = safetyZoneType.getTexture()
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.initializePhysicsProperties(texture: texture)
        
        self.safetyZoneType = safetyZoneType
        
        let mainAnimation = safetyZoneType.getAnimation()
        self.run(SKAction.repeatForever(mainAnimation), withKey: "mainAnimation")
        
        self.xScale *= scale
        self.yScale *= scale
        
    }
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func initializePhysicsProperties(texture: SKTexture){
        self.physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width*1.5)
        self.physicsBody?.categoryBitMask = ColliderType.SafetyZone.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.SafetyZone.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.SafetyZone.contactMask
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        
        
    }
    
    
}
