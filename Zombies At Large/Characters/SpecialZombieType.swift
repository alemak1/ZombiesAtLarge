//
//  SpecialZombieType.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

enum SpecialZombieType: Int{
    
    case CZombie = 0
    case GZombie
    case MZombie
    
    func getSpecialZombieClass() -> Zombie.Type{
        switch self {
        case .CZombie:
            return CamouflageZombie.self
        case .GZombie:
            return GiantZombie.self
        case .MZombie:
            return MiniZombie.self
        default:
            break
        }
    }
}
