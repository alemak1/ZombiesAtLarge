//
//  NonplayerCharacterType.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit



enum NonplayerCharacterType{
    case OldWoman
    case Survivor1
    case Survivor2
    case GreenWoman
    case RedMan
    case BlueMan
    case BrownMan
    case Hitman
    case Robot
    case Zombie1
    case Zombie2
    
    func getTexture() -> SKTexture?{
        
        switch self {
        case .OldWoman:
            return nil
        default:
            return nil
        }
    }
    
    
    func getAvatarType() -> Avatar{
        
        switch self {
        case .OldWoman:
            return .woman
        case .GreenWoman:
            return .womanAlternative
        case .RedMan:
            return .man
        case .BlueMan:
            return .manAlternative
        case .Hitman:
            return .man
        case .BrownMan:
            return .manAlternative
        case .Robot:
            return .robot
        case .Survivor1,.Survivor2:
            return .survivor
        case .Zombie1,.Zombie2:
            return .zombie
            
        }
    }
    
}
