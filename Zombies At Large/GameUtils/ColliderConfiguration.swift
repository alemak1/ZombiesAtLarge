//
//  ColliderConfiguration.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

enum ColliderConfiguration: UInt32 {
    
    case Player =               0b1
    case PlayerProximity =      0b10
    case PlayerBullet =         0b100
    case Enemy =                0b1000
    case EnemyBullet =          0b10000
    case Obstacle =             0b100000
    case Collectible =          0b1000000
    case Explosive =            0b10000000
    case NonPlayerCharacter =   0b100000000
    
    func getCategoryBitmask() -> UInt32{
        return self.rawValue
    }
    
    func getCollisionBitmask() -> UInt32{
        switch self {
        case .Player:
            return ColliderConfiguration.Obstacle.rawValue | ColliderConfiguration.EnemyBullet.rawValue | ColliderConfiguration.Enemy.rawValue
        default:
            return 0
        }
    }
    
    func getContactBitmask() -> UInt32{
       
        switch self{
        case .Collectible:
            return ColliderConfiguration.Player.rawValue
        case .Player:
            return ColliderConfiguration.Collectible.rawValue | ColliderConfiguration.Enemy.rawValue | ColliderConfiguration.EnemyBullet.rawValue | ColliderConfiguration.NonPlayerCharacter.rawValue
        case.PlayerBullet:
            return 0
        case .PlayerProximity:
            return 0
        case .NonPlayerCharacter:
            return 0
        case .Explosive:
            return 0
        case .Enemy:
            return 0
        case .EnemyBullet:
            return 0
        default:
            return 0
        }
    }
}
