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
            return SKTexture(image: #imageLiteral(resourceName: "womanOld_stand"))
        case .Survivor1:
            return SKTexture(image: #imageLiteral(resourceName: "survivor1_stand"))
        case .Survivor2:
            return SKTexture(image: #imageLiteral(resourceName: "survivor2_stand"))
        case .RedMan:
            return SKTexture(image: #imageLiteral(resourceName: "manRed_stand"))
        case .BlueMan:
            return SKTexture(image: #imageLiteral(resourceName: "manBlue_stand"))
        case .BrownMan:
            return SKTexture(image: #imageLiteral(resourceName: "manBrown_stand"))
        case .Hitman:
            return SKTexture(image: #imageLiteral(resourceName: "hitman1_stand"))
        case .Robot:
            return SKTexture(image: #imageLiteral(resourceName: "robot1_stand"))
        case .Zombie1:
            return SKTexture(image: #imageLiteral(resourceName: "zombie1_stand"))
        case .Zombie2:
            return SKTexture(image: #imageLiteral(resourceName: "zombie2_stand"))
        case .GreenWoman:
            return SKTexture(image: #imageLiteral(resourceName: "womanGreen_stand"))
 
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
