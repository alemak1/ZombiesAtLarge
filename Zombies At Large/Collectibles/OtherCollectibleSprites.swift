//
//  OtherCollectibleSprites.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/16/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: CollectibleSprite{
    
    var numberOfBullets: Int = 1
    
    convenience init(numberOfBullets: Int = 1) {
        
        let bulletTexture = CollectibleType.Bullet1.getTexture()
        
        self.init(texture: bulletTexture, color: .clear, size: bulletTexture.size())
        initializePhysicsProperties(withTexture: bulletTexture)
        
        self.numberOfBullets = numberOfBullets
        
        self.name = CollectibleType.Bullet1.getCollectibleName()
        self.collectibleType = CollectibleType.Bullet1
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class RedEnvelope: CollectibleSprite{
    
    var monetaryValue: Double = 100
    
    convenience init(monetaryValue: Double? = nil) {
        
        let redEnvelopeTexture = CollectibleType.RedEnvelope1.getTexture()
        
        self.init(texture: redEnvelopeTexture, color: .clear, size: redEnvelopeTexture.size())
        initializePhysicsProperties(withTexture: redEnvelopeTexture)
        self.monetaryValue = monetaryValue ?? CollectibleType.RedEnvelope1.getMonetaryUnitValue()
        self.name = CollectibleType.RedEnvelope1.getCollectibleName()
        self.collectibleType = CollectibleType.RedEnvelope1

    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RiceBowl: CollectibleSprite{
    
    var healthValue: Int = 2
    
    convenience init(healthValue: Int? = 2) {
        
        let riceBowlTexture = CollectibleType.RiceBowl1.getTexture()
        
        self.init(texture: riceBowlTexture, color: .clear, size: riceBowlTexture.size())
        initializePhysicsProperties(withTexture: riceBowlTexture)
        self.healthValue = healthValue ?? 2
        self.name = CollectibleType.RiceBowl1.getCollectibleName()
        self.collectibleType = CollectibleType.RiceBowl1
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
