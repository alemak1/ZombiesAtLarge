//
//  GameScene+SKPhysicsContactDelegate.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/15/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

/** Conformance to SKPhysicsContactDelegate and implementation of contact logic among player entities **/

extension GameScene: SKPhysicsContactDelegate{
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        handlePlayerContacts(contact: contact)
        handlePlayerProximityContacts(contact: contact)
        handlePlayerBulletContacts(contact: contact)
        
        
    }
    
    
    func handleZombieContacts(contact: SKPhysicsContact){
        
        print("Handling the zombie contacts")
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var nonZombieBody: SKPhysicsBody
        var zombieBody: SKPhysicsBody
        
        if(bodyA.categoryBitMask & ColliderType.Enemy.categoryMask == 1){
            nonZombieBody = bodyB
            zombieBody = bodyA
        } else {
            nonZombieBody = bodyA
            zombieBody = bodyB
        }
        
        
        switch nonZombieBody.categoryBitMask {
        case ColliderType.PlayerBullets.categoryMask:
            print("The zombie has contacted the player bullet")
            break
        case ColliderType.PlayerProximity.categoryMask:
            print("The zombie has contacted the player proximitiy zone")
            break
        default:
            print("No logic implemented for collision btwn zombie and entity of this type")
        }
    }
    
    /** Helper function to implement contact logic between player bullets and entites that have contacted the player bullets **/
    
    func handlePlayerBulletContacts(contact: SKPhysicsContact){
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var playerBulletPB: SKPhysicsBody
        var nonPlayerBulletPB: SKPhysicsBody
        
        if(bodyA.categoryBitMask & ColliderType.PlayerBullets.categoryMask == 1){
            nonPlayerBulletPB = bodyB
            playerBulletPB = bodyA
        } else {
            nonPlayerBulletPB = bodyA
            playerBulletPB = bodyB
        }
        
        switch nonPlayerBulletPB.categoryBitMask {
        case ColliderType.Enemy.categoryMask:
            print("The bullet has hit a zombie")
            if let zombie = nonPlayerBulletPB.node as? Zombie, let playerBullet = playerBulletPB.node as? SKSpriteNode{
                
                zombie.takeHit()
                self.run(SKAction.wait(forDuration: 0.05), completion: {
                    playerBullet.removeFromParent()
                })
                
            }
            break
        default:
            print("No contact logic implemented")
        }
        
    }
    
    
    /** Helper function to implement the contact logic between the player proximity and the entities in contact with the player proximity zone **/
    
    func handlePlayerProximityContacts(contact: SKPhysicsContact){
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var nonplayerProximityPB: SKPhysicsBody
        
        
        if(bodyA.categoryBitMask & ColliderType.PlayerProximity.categoryMask == 1){
            nonplayerProximityPB = bodyB
        } else {
            nonplayerProximityPB = bodyA
        }
        
        switch nonplayerProximityPB.categoryBitMask {
        case ColliderType.Enemy.categoryMask:
            print("The player proximity contacted the zombie")
            if let zombie = nonplayerProximityPB.node as? Zombie{
                zombieManager.activateZombie(zombie: zombie)
            }
            break
        default:
            break
        }
        
    }
    
    
    /** Helper function to implement contact logic between player and the other entity that has contacted a player **/
    
    func handlePlayerContacts(contact: SKPhysicsContact){
        
        print("Processing player contact with other body...")
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        
        var nonPlayerBody: SKPhysicsBody
        
        if((bodyA.categoryBitMask & ColliderType.Player.categoryMask) == 1){
            nonPlayerBody = bodyB
        } else {
            nonPlayerBody = bodyA
        }
        
        
        switch nonPlayerBody.categoryBitMask {
        case ColliderType.Collectible.categoryMask:
            print("The player has contacted a collectible")
            if let collectibleSprite = nonPlayerBody.node as? CollectibleSprite{
                
                let newCollectible = collectibleSprite.getCollectible()
                
                player.addCollectibleItem(newCollectible: newCollectible){
                    
                    self.player.playSoundForCollectibleContact()
                    
                    
                    collectibleSprite.removeFromParent()
                    
                }
                
            }
            break
            
        default:
            print("Failed to process player contact with entity: No contact logic implemented for contact between player and this entity")
        }
    }
    
}

