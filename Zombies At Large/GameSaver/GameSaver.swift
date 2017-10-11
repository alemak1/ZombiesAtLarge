//
//  GameSaver.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CoreData

class GameSaver{
    
    var managedContext: NSManagedObjectContext{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Error: unable to access the appDelegate")}
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var entityDescription: NSEntityDescription{
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "SavedGame", in: self.managedContext)!
        
        return entityDescription
    }
    
    
    
    var zombieSnapshotEntityDescription: NSEntityDescription{
        let entityDescription = NSEntityDescription.entity(forEntityName: "ZombieSnapshot", in: self.managedContext)!
        
        return entityDescription
    }
    
    var rescueCharConfigurationEntityDescription: NSEntityDescription{
        let entityDescription = NSEntityDescription.entity(forEntityName: "RescueCharConfiguration", in: self.managedContext)!
        
        return entityDescription
    }
    
    var playerCollectibleConfigurationEntityDescription: NSEntityDescription{
        let entityDescription = NSEntityDescription.entity(forEntityName: "PlayerCollectibleConfiguration", in: self.managedContext)!
        
        return entityDescription
    }
    
    var zombieSnapShotGroupEntityDescription: NSEntityDescription{
        let entityDescription = NSEntityDescription.entity(forEntityName: "ZombieSnapshotGroup", in: self.managedContext)!
        
        return entityDescription
    }
    
    var collectibleSpriteSnapshotEntityDescription: NSEntityDescription{
        let entityDescription = NSEntityDescription.entity(forEntityName: "CollectibleSpriteSnapshot", in: self.managedContext)!
        
        return entityDescription
    }
    
    var collectibleSpriteSnapshotGroupEntityDescription: NSEntityDescription{
        let entityDescription = NSEntityDescription.entity(forEntityName: "CollectibleSpriteSnapshotGroup", in: self.managedContext)!
        
        return entityDescription
    }
    
    var gameScene: GameScene
    
    init(withGameScene gameScene: GameScene){
        self.gameScene = gameScene
    
    }
    
    
    func saveGame(){
        
        print("GameSaver is proceeding to save game...")
        
        
        let savedGame = SavedGame(entity: self.entityDescription, insertInto: self.managedContext)
        
        savedGame.date = Date() as NSDate
        savedGame.level = Int16(self.gameScene.currentGameLevel.rawValue)
        savedGame.playerSnapshot = self.gameScene.player.playerStateSnapShot
        savedGame.playerProfile = self.gameScene.currentPlayerProfile
        
        
        let collectibleSpriteConfigs = self.gameScene.worldNode.getWorldNodeConfiguration().collectibleSpriteConfigurations
        
        print("Collectible sprite configs: \(collectibleSpriteConfigs.debugDescription)")
        
        let zombieConfigs = self.gameScene.worldNode.getWorldNodeConfiguration().zombieConfigurations
        
        print("zombie sprite configs: \(zombieConfigs.debugDescription)")

        
        let zg = ZombieSnapshotGroup(entity: self.zombieSnapShotGroupEntityDescription, insertInto: self.managedContext)
        
        let cg = CollectibleSpriteSnapshotGroup(entity: self.collectibleSpriteSnapshotGroupEntityDescription, insertInto: self.managedContext)
        
        
        
        collectibleSpriteConfigs.forEach({
            
            collectibleSpriteConfig in
            
            if !collectibleSpriteConfig.isRequired{
                
                let cSnapshot = CollectibleSpriteSnapshot(entity: self.collectibleSpriteSnapshotEntityDescription, insertInto: self.managedContext)
            
                cSnapshot.position = collectibleSpriteConfig.position as NSObject
                cSnapshot.collectibleTypeRawValue = Int32(collectibleSpriteConfig.collectibleTypeRawValue)
                cSnapshot.isRequired = collectibleSpriteConfig.isRequired
                cSnapshot.collectibleSpriteSnapshotGroup = cg
            }
            
        })
        
        
        zombieConfigs.forEach({
            
            zombieConfig in
            
            if !zombieConfig.isMustKill{
                let zSnapshot = ZombieSnapshot(entity: self.zombieSnapshotEntityDescription, insertInto: self.managedContext)
            
                zSnapshot.currentHealth = zombieConfig.currentHealth
                zSnapshot.currentModeRawValue = zombieConfig.currentModeRawValue
                zSnapshot.frameCount = zombieConfig.frameCount
                zSnapshot.isActive = zombieConfig.isActive
                zSnapshot.isDamaged = zombieConfig.isDamaged
                zSnapshot.position = zombieConfig.position as NSObject
                zSnapshot.shootingFrameCount = zombieConfig.shootingFrameCount
                zSnapshot.zombieTypeRawValue = zombieConfig.zombieTypeRawValue
            
            zSnapshot.zombieSnapshotGroup = zg
            }
            
        })
        
        
       
        
      self.gameScene.player.collectibleManager.getCollectiblesArray().forEach({
        
        c1 in
        
        let newCollectibleConfiguration = PlayerCollectibleConfiguration(entity: self.playerCollectibleConfigurationEntityDescription, insertInto: self.managedContext)
        
        newCollectibleConfiguration.canBeActivated = c1.getCanBeActivatedStatus()
        newCollectibleConfiguration.isActive = c1.getActiveStatus()
        newCollectibleConfiguration.totalQuantity = Int64(c1.getQuantityOfCollectible())
        newCollectibleConfiguration.collectibleTypeRawValue = Int64(c1.getCollectibleType().rawValue)
        
        newCollectibleConfiguration.savedGame = savedGame
        
      })
        
        
        
        var requiredCollectibleSnapshots = Set<CollectibleSpriteSnapshot>()
        
        self.gameScene.requiredCollecribles?.forEach({
            
            requiredCollectible in
            
            
            let requiredCollectibleSnapshot = CollectibleSpriteSnapshot(entity: self.collectibleSpriteSnapshotEntityDescription, insertInto: self.managedContext)
            
            requiredCollectibleSnapshot.isRequired = requiredCollectible.isRequired
            requiredCollectibleSnapshot.position = requiredCollectible.position as NSObject
            requiredCollectibleSnapshot.collectibleTypeRawValue = Int32(requiredCollectible.collectibleType.rawValue)
            
            requiredCollectibleSnapshots.insert(requiredCollectibleSnapshot)
            
        })
        
        savedGame.requiredCollectibles = requiredCollectibleSnapshots as NSSet
        
        
        var mustKillZombieSnapshots  = Set<ZombieSnapshot>()

        self.gameScene.mustKillZombies?.map({$0.getZombieConfiguration()}).forEach({
            
            mustKillZombie in
            
            let zombieSnapshot = ZombieSnapshot(entity: self.zombieSnapshotEntityDescription, insertInto: self.managedContext)
            
            zombieSnapshot.isActive = mustKillZombie.isActive
            zombieSnapshot.isDamaged = mustKillZombie.isDamaged
            zombieSnapshot.frameCount = mustKillZombie.frameCount
            zombieSnapshot.shootingFrameCount = mustKillZombie.shootingFrameCount
            zombieSnapshot.currentHealth = mustKillZombie.currentHealth
            zombieSnapshot.currentModeRawValue = mustKillZombie.currentModeRawValue
            zombieSnapshot.zombieTypeRawValue = mustKillZombie.zombieTypeRawValue
            
            
        })
        
        savedGame.mustKillZombies = mustKillZombieSnapshots as NSSet
        
        
        
        self.gameScene.unrescuedCharacters?.forEach({
            
            rescueCharacter in
            
           let rescueCharConfiguration = RescueCharConfiguration(entity: self.rescueCharConfigurationEntityDescription, insertInto: self.managedContext)
            
            rescueCharConfiguration.compassDirectionRawValue = Int64(rescueCharacter.compassDirection.rawValue)
            rescueCharConfiguration.hasBeenRescued = rescueCharacter.hasBeenRescued
            rescueCharConfiguration.nonplayerTypeCharacter = Int64(rescueCharacter.nonPlayerCharacterType.rawValue)
            
            rescueCharConfiguration.savedGame = savedGame
            
        })
        
        savedGame.collectibleSpriteSnapshotGroup = cg
        savedGame.zombieSnapshotGroup = zg
        
        print("About to save game with debug description of \(savedGame.debugDescription)")
        
        do {
            try self.managedContext.save()
            print("Game saved successfully!")
        } catch let error as NSError {
            print("Error: unable to save game due to error \(error.localizedDescription), reason: \(error.localizedFailureReason)")
        }
    
    }
    

}
