//
//  MiniZombie.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class MiniZombie: Zombie, Updateable{
    
    
    required init?(coder aDecoder: NSCoder) {
        let compassDirectionRawValue = aDecoder.decodeInteger(forKey: "compassDirectionRawValue")
        self.compassDirection = CompassDirection(rawValue: compassDirectionRawValue)!
        self.hasDirectionChangeEnabled = aDecoder.decodeBool(forKey: "hasDirectionChangeEnabled")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.hasDirectionChangeEnabled, forKey: "hasDirectionChangeEnabled")
        aCoder.encode(self.compassDirection.rawValue, forKey: "compassDirectionRawValue")
    }
    
    var impulseInterval: TimeInterval = 1.00
    var impulseFrameCount: TimeInterval = 0.00
    var directionChangeFrameCount: TimeInterval = 0.00
    var directionChangeInterval: TimeInterval = 2.00
    var lastImpulseUpdateTime: TimeInterval = 0.00
    
    var hasDirectionChangeEnabled = false
    
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
    convenience init(zombieType: ZombieType, scale: CGFloat = 0.40, startingHealth: Int = 1, hasDirectionChangeEnabled: Bool = false) {
        
        
        let defaultTexture = zombieType.getDefaultTexture()
        
        self.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        
        configurePhysicsProperties(withTexture: defaultTexture, andWithSize: defaultTexture.size())
        
        self.physicsBody?.allowsRotation = false
        
        self.zombieType = zombieType
        self.currentHealth = startingHealth
        self.hasDirectionChangeEnabled = false
        
        self.xScale *= scale
        self.yScale *= scale
        
    }
    
    
    func updateMovement(forTime currentTime: TimeInterval){
        
        if(lastImpulseUpdateTime == 0){
            
            lastImpulseUpdateTime = currentTime;
            
        }
    
        impulseFrameCount += currentTime - lastImpulseUpdateTime
       
        if(impulseFrameCount > impulseInterval){
            
    
            if hasDirectionChangeEnabled{
                print("Getting random compass direction")
                compassDirection = CompassDirection.GetRandomDirection()
                print("Getting random compass direction...\(compassDirection)")

    
            }
            
            let xImpulse = appliedUnitVector.dx
            let yImpulse = appliedUnitVector.dy
            
            let appliedVector = CGVector(dx: 5.00*xImpulse, dy: 5.00*yImpulse)
            
            self.physicsBody?.applyImpulse(appliedVector)
            
            impulseFrameCount = 0.00
        }
        
    
        
        self.lastImpulseUpdateTime = currentTime
    }
    
    
    func adjustDirectionOnContact(){
        
        self.compassDirection = CompassDirection.GetRandomDirection()
        
    }
    
    
    
    //MARK: ********* Designated and required initializers
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        self.compassDirection = .east

        super.init(texture: texture, color: color, size: size)
    }
    
  
}
