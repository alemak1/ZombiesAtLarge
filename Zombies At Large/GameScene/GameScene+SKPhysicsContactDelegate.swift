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
        
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        

        
        switch (contactA.categoryBitMask,contactB.categoryBitMask) {
        case (let x, let y) where x == ColliderType.RescueCharacter.categoryMask ||  y == ColliderType.RescueCharacter.categoryMask:
            handleRescueCharacterContacts(contact: contact)
            break
        case (let x, let y) where x == ColliderType.PlayerBullets.categoryMask ||  y == ColliderType.PlayerBullets.categoryMask:
            handlePlayerBulletContacts(contact: contact)
            break
        case (let x, let y) where x == ColliderType.Player.categoryMask || y == ColliderType.Player.categoryMask:
                handlePlayerContacts(contact: contact)
                break
        case (let x, let y) where x == ColliderType.Obstacle.categoryMask ||  y == ColliderType.Obstacle.categoryMask:
                handleObstacleContacts(contact: contact)
                break
        case (let x, let y) where x == ColliderType.PlayerBullets.categoryMask ||  y == ColliderType.PlayerBullets.categoryMask:
            handlePlayerBulletContacts(contact: contact)
            break
        case (let x, let y) where x == ColliderType.SafetyZone.categoryMask ||  y == ColliderType.SafetyZone.categoryMask:
            break
        case (let x, let y) where x == ColliderType.PlayerProximity.categoryMask ||  y == ColliderType.PlayerProximity.categoryMask:
            handlePlayerProximityContacts(contact: contact)
            break
        case (let x, let y) where x == ColliderType.EnemyBullets.categoryMask ||  y == ColliderType.EnemyBullets.categoryMask:
            handleEnemyBulletContacts(contact: contact)
            break
        default:
            break
        }
        
        
        
        
        
    /**
        switch (contactB.categoryBitMask,contactA.categoryBitMask) {
        case (ColliderType.SafetyZone.categoryMask,ColliderType.RescueCharacter.categoryMask),(ColliderType.RescueCharacter.categoryMask,ColliderType.SafetyZone.categoryMask):
            if let rescueCharacter = contactA.node as? RescueCharacter{
                unrescuedCharacters.remove(rescueCharacter)
                print("The unrescued character count is: \(unrescuedCharacters.count)")
            } else if let rescueCharacter = contactB.node as? RescueCharacter{
                unrescuedCharacters.remove(rescueCharacter)
                print("The unrescued character count is: \(unrescuedCharacters.count)")
            }
            break
        default:
            break
        }
     **/
    
    
        handlePlayerProximityContacts(contact: contact)
        handlePlayerContacts(contact: contact)

        
    }
    
    typealias BitmaskTuple = (a: UInt32, b: UInt32)
    
    func swapBitmasks(bitmaskTuple: BitmaskTuple) -> (UInt32,UInt32){
        
        return (bitmaskTuple.b,bitmaskTuple.a)
    }
    
    
    func handleRescueCharacterContacts(contact: SKPhysicsContact){
        
        print("Handling RESCUE CHARACTER contacts")
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var nonRescueCharacterBody: SKPhysicsBody
        var rescueCharacterBody: SKPhysicsBody
        
        if(bodyA.categoryBitMask & ColliderType.RescueCharacter.categoryMask == 1){
            nonRescueCharacterBody = bodyB
            rescueCharacterBody = bodyA
        } else {
            nonRescueCharacterBody = bodyA
            rescueCharacterBody = bodyB
        }
        
        
        switch nonRescueCharacterBody.categoryBitMask {
        case ColliderType.PlayerProximity.categoryMask:
            print("handleRescueCharacter: The RESCUE CHARACTER has been resuced!!!")
            if let rescueCharacter = rescueCharacterBody.node as? RescueCharacter{
                rescueCharacter.rescueCharacter()
            }
            break
        case ColliderType.SafetyZone.categoryMask:
            print("handleRescueCharacter: The RESCUE CHARACTER has arrived at the SAFETY ZONE!!!")
            if let rescueCharacter = rescueCharacterBody.node as? RescueCharacter{
                unrescuedCharacters.remove(rescueCharacter)
                print("The unrescued character count is: \(unrescuedCharacters.count)")
            }
            break
        case ColliderType.EnemyBullets.categoryMask:
            print("handleRescueCharacter: The RESCUE CHARACTER HAS BEEN HIT BY A ZOMBIE")
            if let rescueCharacter = rescueCharacterBody.node as? RescueCharacter{
                rescueCharacter.unrescueCharacter()
            }
            break
        default:
            break
        }
        
    }
    
    func handleObstacleContacts(contact: SKPhysicsContact){
        
        print("Handling the obstacle contacts")
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var nonObstacleBody: SKPhysicsBody
        var obstacleBody: SKPhysicsBody
        
        if(bodyA.categoryBitMask & ColliderType.Obstacle.categoryMask == 1){
            nonObstacleBody = bodyB
            obstacleBody = bodyA
        } else {
            nonObstacleBody = bodyA
            obstacleBody = bodyB
        }
        
        
        switch nonObstacleBody.categoryBitMask {
            
        case ColliderType.Enemy.rawValue:
            print("Obstacle has contacted a zombie")
            if let minizombie = nonObstacleBody.node as? MiniZombie{
                
                print("Adjusting the zombie's direction")

                minizombie.adjustDirectionOnContact()
            }
            break
        default:
            break
        }
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
        
            case ColliderType.Obstacle.rawValue:
                print("Zombie has contacted a wall")
                if let minizombie = zombieBody.node as? MiniZombie{
                    print("Adjusting the zombie's direction")
                    minizombie.adjustDirectionOnContact()
                }
            break
            case ColliderType.PlayerBullets.categoryMask:
                print("The zombie has contacted the player bullet")
                break
            case ColliderType.PlayerProximity.categoryMask:
                print("The zombie has contacted the player proximitiy zone")
                break
            default:
                break
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
            if let zombie = nonPlayerBulletPB.node as? Zombie, let playerBullet = playerBulletPB.node as? SKSpriteNode{
                
                zombie.takeHit()
                
                self.run(SKAction.wait(forDuration: 0.05), completion: {
                    playerBullet.removeFromParent()
                })
                
            }
            break
        case ColliderType.Obstacle.categoryMask:
            if let playerBullet = playerBulletPB.node as? SKSpriteNode{
                self.run(SKAction.wait(forDuration: 0.05), completion: {
                    playerBullet.removeFromParent()
                })
            }
            break
        case ColliderType.Bomb.categoryMask:
            if let bomb = nonPlayerBulletPB.node as? Bomb{
                
                bomb.runExplosionAnimation()
            }
            break
        default:
            break
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
            if let zombie = nonplayerProximityPB.node as? Zombie{
                zombieManager.activateZombie(zombie: zombie)
            }
            break
        case ColliderType.RescueCharacter.categoryMask:
            if let rescueCharacter = nonplayerProximityPB.node as? RescueCharacter{
                print("Character has been rescued")
                rescueCharacter.rescueCharacter()
            }
            break
        case ColliderType.SafetyZone.categoryMask:
            print("Player HAS REACHED the SAFETY ZONE")
            break
        case ColliderType.NonPlayerCharacter.categoryMask:
            if let npc = nonplayerProximityPB.node as? SKSpriteNode{
                if npc.name == "Trader"{
                    showMerchantPrompt()
                }
                
                if npc.name == "CameraZombie"{
                    
                }
                
                if npc.name == "Cartographer"{
                    
                }
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
        case ColliderType.Bomb.categoryMask:
            break
        case ColliderType.SafetyZone.categoryMask:
            print("Player HAS REACHED the SAFETY ZONE")
            break
        case ColliderType.Collectible.categoryMask:
            print("The player has contacted a collectible")
            
            if let scroll = nonPlayerBody.node as? Scroll{
                
            }
            

            if let collectibleSprite = nonPlayerBody.node as? CollectibleSprite{
                
                
                if collectibleSprite.name == "RedEnvelope",let redEnvelope = collectibleSprite as? RedEnvelope{
                    
                    
                    let newCollectible = redEnvelope.getCollectible()
                    
                    player.addCollectibleItem(newCollectible: newCollectible){
                        
                        self.player.playSoundForCollectibleContact()
                        
                        
                        collectibleSprite.removeFromParent()
                        
                    }
                    return
                }
                
                if collectibleSprite.name == "Bullet",let bullet = collectibleSprite as? Bullet{
                    
                    if(self.player.updatingBulletCount) { return }
                    
                    run(SKAction.run {
                        self.player.updatingBulletCount = true
                        bullet.removeFromParent()
                    }, completion: {
                        self.player.playSoundForCollectibleContact()
                        self.player.increaseBullets(byBullets: bullet.numberOfBullets)
                        self.player.updatingBulletCount = false

                    })
                    
                   
                
                    

                    return
                }
                
                if collectibleSprite.name == "RiceBowl", let riceBowl = collectibleSprite as? RiceBowl{
            
                    self.player.increaseHealth(byHealthUnits: riceBowl.healthValue)
                    self.player.playSoundForCollectibleContact()
                    collectibleSprite.removeFromParent()
                    return
                }
                
                let newCollectible = collectibleSprite.getCollectible()
                
                player.addCollectibleItem(newCollectible: newCollectible){
                    
                    self.player.playSoundForCollectibleContact()
                    
                    collectibleSprite.removeFromParent()
                    
                    if collectibleSprite.name == "RequiredCollectible"{
                        self.requiredCollectibles.remove(collectibleSprite)
                    }
                    
                }
                
            }
            break
        case ColliderType.EnemyBullets.categoryMask:
            if let zombieBullet = nonPlayerBody.node as? SKSpriteNode{
                
                player.run(SKAction.run {
                    
                    zombieBullet.removeFromParent()
                    
                    }, completion: {
                        
                            self.player.takeDamage()
                        

                })
                
            }
            break
        default:
            break
        }
    }
    
    
    
    
    func handleEnemyBulletContacts(contact: SKPhysicsContact){
        
        print("Processing enemy bullet contact with other body...")
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        
        var nonBulletBody: SKPhysicsBody
        var bulletBody: SKPhysicsBody
        
        if((bodyA.categoryBitMask & ColliderType.EnemyBullets.categoryMask) == 1){
            nonBulletBody = bodyB
            bulletBody = bodyA
        } else {
            nonBulletBody = bodyA
            bulletBody = bodyB

        }
        
        
        switch nonBulletBody.categoryBitMask {
      
        case ColliderType.Obstacle.categoryMask:
            if let zombieBullet = bulletBody.node as? SKSpriteNode{
                
                zombieBullet.run(SKAction.wait(forDuration: 0.10), completion: {
                    zombieBullet.removeFromParent()
            
                })
            }
            break
        default:
            break
        }
    }
    
    
    func handleSafetyZoneContacts(contact: SKPhysicsContact){
        
        print("Handling safety zone  contacts")
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var nonSafetyZoneBody: SKPhysicsBody
        var safetyZoneBody: SKPhysicsBody
        
        if(bodyA.categoryBitMask & ColliderType.SafetyZone.categoryMask == 1){
            nonSafetyZoneBody = bodyB
            safetyZoneBody = bodyA
        } else {
            nonSafetyZoneBody = bodyA
            safetyZoneBody = bodyB
        }
        
        
        switch nonSafetyZoneBody.categoryBitMask {
        case ColliderType.RescueCharacter.categoryMask:
            print("The RESCUE CHARACTER has arrived at the SAFETY ZONE!!!")
            if let rescueCharacter = nonSafetyZoneBody.node as? RescueCharacter{
               unrescuedCharacters.remove(rescueCharacter)
                print("The unrescued character count is: \(unrescuedCharacters.count)")
            }

            break
        default:
            break
        }
        
    }
    
}

