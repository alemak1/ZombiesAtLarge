//
//  ColliderType.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/6/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


struct ColliderType: OptionSet, Hashable{
    
    
    //MARK: Static properties
    
    //A dictionary of which ColliderType's should collide with other ColliderType's
    static var definedCollisions: [ColliderType:[ColliderType]] = [
    
        ColliderType.Player : [ColliderType.Enemy, ColliderType.EnemyBullets, ColliderType.Obstacle,ColliderType.Bomb],
        ColliderType.Enemy: [ColliderType.PlayerBullets,ColliderType.Player,ColliderType.Enemy,ColliderType.Obstacle],
        ColliderType.PlayerBullets: [ColliderType.Obstacle,ColliderType.Enemy],
        ColliderType.PlayerProximity: [],
        ColliderType.EnemyBullets: [ColliderType.Player,ColliderType.Obstacle],
        ColliderType.Collectible: [ColliderType.Obstacle],
        ColliderType.Obstacle: [ColliderType.Collectible,ColliderType.Player,ColliderType.Enemy,ColliderType.PlayerBullets,ColliderType.EnemyBullets],
        ColliderType.NonPlayerCharacter: [],
        ColliderType.Explosive: [],
        ColliderType.Bomb: [ColliderType.Player]
    
    ]
    
    //A dictionary to specify which ColliderType's should be notified of contact with other ColliderType's
    static var requestedContactNotifications: [ColliderType:[ColliderType]] =  [
        
        ColliderType.Player : [ColliderType.Collectible,ColliderType.Explosive,ColliderType.EnemyBullets],
        ColliderType.Enemy: [ColliderType.PlayerProximity,ColliderType.PlayerBullets],
        ColliderType.PlayerBullets: [ColliderType.Explosive,ColliderType.Enemy,ColliderType.Obstacle,ColliderType.Bomb],
        ColliderType.PlayerProximity: [ColliderType.Enemy],
        ColliderType.EnemyBullets: [ColliderType.Explosive,ColliderType.Player,ColliderType.Obstacle],
        ColliderType.Collectible: [ColliderType.Player],
        ColliderType.Obstacle: [ColliderType.PlayerBullets],
        ColliderType.Explosive: [ColliderType.PlayerBullets,ColliderType.EnemyBullets,ColliderType.Player],
        ColliderType.NonPlayerCharacter: [ColliderType.Player],
        ColliderType.Bomb: [ColliderType.Player,ColliderType.PlayerBullets]
        
    ]

    
    //MARK: Properties
    
    let rawValue: UInt32
    
    static var Player: ColliderType { return self.init(rawValue: 1 << 0)}
    static var PlayerProximity: ColliderType { return self.init(rawValue: 1 << 1)}
    static var PlayerBullets: ColliderType { return self.init(rawValue: 1 << 2)}
    static var Obstacle: ColliderType { return self.init(rawValue: 1 << 3)}
    static var Collectible: ColliderType { return self.init(rawValue: 1 << 4)}
    static var Enemy: ColliderType { return self.init(rawValue: 1 << 5)}
    static var EnemyBullets: ColliderType { return self.init(rawValue: 1 << 6)}
    static var NonPlayerCharacter: ColliderType { return self.init(rawValue: 1 << 7)}
    static var Explosive: ColliderType { return self.init(rawValue: 1 << 8)}
    static var Bomb: ColliderType { return self.init(rawValue: 1 << 9)}
    
    //MARK: Hashable
    
    var hashValue: Int{
        return Int(self.rawValue)
    }
    
    //MARK: SpriteKit Physics Convenience
    
    //A value that can be assigned to an SKPhysicsBody's category mask property
    
    var categoryMask: UInt32{
        return rawValue
    }
    
    //A value that can be assigned to an SKPhysicsBody's collision mask property
    
    var collisionMask: UInt32{
        let mask = ColliderType.definedCollisions[self]?.reduce(ColliderType()){
            
            initial, colliderType in
            
            return initial.union(colliderType)
        }
        
        return mask?.rawValue ?? 0
    }
    
    //A value that can be assigned to an SKPhysicsBody's contact mask property
    
    var contactMask: UInt32{
        let mask = ColliderType.requestedContactNotifications[self]?.reduce(ColliderType()){
            
            initial, colliderType in
            
            return initial.union(colliderType)
            
        }
        
        return mask?.rawValue ?? 0
    }
    
}

