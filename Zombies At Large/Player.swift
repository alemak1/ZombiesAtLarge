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
    
    
    enum Orientation{
        case up,down,left,right
        
        func getOppositeOrientation() -> Orientation{
            switch self {
            case .up:
                return .down
            case .down:
                return .up
            case .left:
                return .right
            case .right:
                return .left

            }
        }
        
        func getAdjacentCounterClockwiseOrientation() -> Orientation{
            switch self {
            case .up:
                return .left
            case .down:
                return .right
            case .left:
                return .down
            case .right:
                return .up
                
            }
            
        }
        
        func getAdjacentClockwiseOrientation() -> Orientation{
            switch self {
            case .up:
                return .right
            case .down:
                return .left
            case .left:
                return .up
            case .right:
                return .down
                
            }
            
        }
    }
    
    var playerType: PlayerType
    
    private var appliedUnitVector: CGVector{
        
        switch currentOrientation {
        case .up:
            return CGVector(dx: 0.00, dy: 1.00)
        case .down:
            return CGVector(dx: 0.00, dy: -1.00)
        case .left:
            return CGVector(dx: -1.00, dy: 0.0)
        case .right:
            return CGVector(dx: 1.00, dy: 0.0)
        }
       
    }
    
    
    
    var currentOrientation: Orientation{
        didSet{
            
            guard oldValue != currentOrientation else { return }
            
            print("The player orientation has changed")
            
            var angleOfRotaiton: Double = 0.00
            
            if(oldValue == currentOrientation.getOppositeOrientation()){
                angleOfRotaiton = Double.pi
            } else if (oldValue == currentOrientation.getAdjacentClockwiseOrientation()){
                angleOfRotaiton = Double.pi/2
            } else if (oldValue == currentOrientation.getAdjacentCounterClockwiseOrientation()){
                angleOfRotaiton = -Double.pi/2
            }
            
            run(SKAction.rotate(byAngle: CGFloat(angleOfRotaiton), duration: 0.30))
        }
     
     }
 
    
 
    
    convenience init(playerType: PlayerType, scale: CGFloat){
        self.init(playerType: playerType)
        
        self.xScale *= scale
        self.yScale *= scale
    }
    
    convenience init(playerType: PlayerType){
        
        let playerTexture = playerType.getTexture(textureType: .gun)
        
        self.init(texture: playerTexture, color: .clear, size: playerTexture.size())
       
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let defaultPlayerType = PlayerType(rawValue: "manBlue")!
        
        self.playerType = defaultPlayerType
        self.currentOrientation = .right
        
        let texture = texture ?? defaultPlayerType.getTexture(textureType: .gun)
        
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.linearDamping = 2.00
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
    
}


