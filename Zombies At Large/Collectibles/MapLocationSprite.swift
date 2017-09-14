//
//  MapLocationSprite.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/14/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class MapLocationSprite: CollectibleSprite{
    
    
    var mapLocation: MapLocation!
    
    convenience init(mapLocation: MapLocation, scale: CGFloat = 1.00) {
        
        let texture = CollectibleType.CompassPointB.getTexture()
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.collectibleType = CollectibleType.CompassPointB
        
        self.mapLocation = mapLocation
        self.initializePhysicsProperties(withTexture: texture)
        
        self.xScale *= scale
        self.yScale *= scale
        

        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
