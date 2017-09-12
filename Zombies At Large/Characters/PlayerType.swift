//
//  PlayerType.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayerType: String{
    case manBlue
    case manRed
    case manBrown
    case survivor1
    case survivor2
    case hitman1
    case womanOld
    case womanGreen
    case soldier1
    case soldier2
    
    
    enum TextureType: String{
        case stand
        case gun
        case hold
        case reload
        case machine
        case silencer
    }

    
    func getTexture(textureType: TextureType) -> SKTexture{
        
        return SKTexture(imageNamed: self.getTextureName(textureType: textureType))
    
    }
    
    
    func getTextureName(textureType: TextureType) -> String{
        
        var baseString = self.rawValue
        
        baseString.append("_\(textureType.rawValue)")
        
        return baseString

      
    }
}
