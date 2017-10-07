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
    
    var gameScene: GameScene
    
    init(withGameScene gameScene: GameScene){
        self.gameScene = gameScene
    
    }
    
    
    func saveGame(withPlayerSnapshot playerSnapshot: PlayerStateSnapShot, gameSceneSnapshot: GameSceneSnapshot){
        
        print("GameSaver is proceeding to save game...")
        
        let savedGame = SavedGame(entity: self.entityDescription, insertInto: self.managedContext)
        
        savedGame.playerProfile = gameScene.currentPlayerProfile!
        savedGame.date = Date() as NSDate
        savedGame.level = Int16(gameScene.currentGameLevel.rawValue)
        savedGame.gameSceneSnapshot = gameSceneSnapshot
        savedGame.playerSnapshot = playerSnapshot
        
       
        
        do {
            try self.managedContext.save()
            print("Game saved successfully!")
        } catch let error as NSError {
            print("Error: unable to save game due to error \(error.localizedDescription), reason: \(error.localizedFailureReason)")
        }
    
    }
    

}
