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
    
    var playerType: PlayerType
    
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
       
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let defaultPlayerType = PlayerType(rawValue: "manBlue")!
        
        self.playerType = defaultPlayerType
        self.compassDirection = .east
        
        let texture = texture ?? defaultPlayerType.getTexture(textureType: .gun)
        
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
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
    
}


