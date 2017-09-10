//
//  BarrelNode.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class BarrelNode: SKSpriteNode{
    
    
    var compassDirection: CompassDirection{
        didSet{
            
            guard oldValue != compassDirection else { return }
            
            let rotation = ((compassDirection.zRotation - oldValue.zRotation) <= CGFloat.pi) && (compassDirection.zRotation > oldValue.zRotation)  ? (compassDirection.zRotation - oldValue.zRotation) : -(oldValue.zRotation - compassDirection.zRotation)
            
            
            run(SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.10))
            
            
        }
    }
    
    convenience init(tankColor: TankColor) {
        
        let barrelTexture = tankColor.getBarrelTexture()
        
        self.init(texture: barrelTexture, color: .clear, size: barrelTexture.size())
        
        self.name = "barrel"
        self.anchorPoint = CGPoint(x: 0, y: 0.5)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.compassDirection = .east
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.compassDirection = .east
        
        super.init(coder: aDecoder)
    }
    
}
