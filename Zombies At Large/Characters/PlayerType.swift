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

    
    init(withIntegerValue intValue: Int){
        switch intValue {
        case 1:
            self = .manBlue
            break
        case 2:
            self = .manRed
            break
        case 3:
            self = .manBrown
            break
        case 4:
            self = .survivor1
            break
        case 5:
            self = .survivor2
            break
        case 6:
            self = .hitman1
            break
        case 7:
            self = .womanOld
            break
        case 8:
            self = .womanGreen
            break
        case 9:
            self = .soldier1
            break
        case 10:
            self = .soldier2
            break
        default:
            self = .manBlue
        }
    }
    
    func getIntegerValue() -> Int{
        switch self {
        case .manBlue:
            return 1
        case .manRed:
            return 2
        case .manBrown:
            return 3
        case .survivor1:
            return 4
        case .survivor2:
            return 5
        case .hitman1:
            return 6
        case .womanOld:
            return 7
        case .womanGreen:
            return 8
        case .soldier1:
            return 9
        case .soldier2:
            return 10
  
        }
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
