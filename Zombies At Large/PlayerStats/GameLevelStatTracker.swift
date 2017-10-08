//
//  GameLevelStatTracker.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CoreData

/** The StatTracker protocol is implemented by different classes, which in turn have different ways of implementing data schemas and managed object contexts; all classes conforming to the protocol must be able to save the basic statistics that are recorded for all types of levels (WordGameLevel, GameLevel, etc **/

protocol StatTracker{
    
    var currentPlayerProfile: PlayerProfile { get set}
    var date: Date { get set }
    var numberOfZombiesKilled: Int { get set }
    var numberOfBulletsFired: Int { get set }
    var totalValueOfCollectibles: Double { get set }
    var totalNumberOfCollectibles: Int { get set}
    
    
    var managedContext: NSManagedObjectContext{ get }
    var entityDescription: NSEntityDescription{ get }
    
    init(playerProfile: PlayerProfile)
    
    func saveGameLevelStats()
    
}

class WordGameLeveStatTracker: StatTracker{
    
    var wordGameLevel: WordGameLevel
   
    var currentPlayerProfile: PlayerProfile
    var date: Date = Date()
    var numberOfZombiesKilled: Int = 0
    var numberOfBulletsFired: Int = 0
    var totalValueOfCollectibles: Double = 0
    var totalNumberOfCollectibles: Int = 0
   
    var managedContext: NSManagedObjectContext{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: failed to load the managed object context for the game level stat tracker")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var entityDescription: NSEntityDescription{
        return NSEntityDescription()
    }
    

   
    init(wordGameLevel: WordGameLevel, playerProfile: PlayerProfile) {
        self.wordGameLevel = wordGameLevel
        self.currentPlayerProfile = playerProfile
        
    }
    
    required init(playerProfile: PlayerProfile){
        self.currentPlayerProfile = playerProfile
        self.wordGameLevel = .Level1
    }

    
    func saveGameLevelStats() {
        print("Game saved!")
    }
}

class GameLevelStatTracker: StatTracker{
    
    var gameLevel: GameLevel
    
    var currentPlayerProfile: PlayerProfile
    var date: Date = Date()
    var numberOfZombiesKilled: Int = 0
    var numberOfBulletsFired: Int = 0
    var totalValueOfCollectibles: Double = 0
    var totalNumberOfCollectibles: Int = 0
    
    lazy var allGameSessionsFetchRequest: NSFetchRequest<GameLevelStatReview> = {
        
        let fetchRequest = NSFetchRequest<GameLevelStatReview>(entityName: "GameLevelStatReview")
        
        return fetchRequest
    }()
    
    
    init(gameLevel: GameLevel, playerProfile: PlayerProfile) {
        self.gameLevel = gameLevel
        self.currentPlayerProfile = playerProfile
        
    }
    
    required init(playerProfile: PlayerProfile){
        self.currentPlayerProfile = playerProfile
        self.gameLevel = .Level1
    }
    
    
    var managedContext: NSManagedObjectContext{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: failed to load the managed object context for the game level stat tracker")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
      var entityDescription: NSEntityDescription{
        return NSEntityDescription.entity(forEntityName: "GameLevelStatReview", in: self.managedContext)!
    }
    
    

    
    
    
    
     func saveGameLevelStats(){

        let statReview = GameLevelStatReview(entity: self.entityDescription, insertInto: self.managedContext)
        
        statReview.date = self.date as NSDate
        statReview.gameLevel = Int64(self.gameLevel.rawValue)
        statReview.numberOfBulletsFired = Int64(self.numberOfBulletsFired)
        statReview.numberOfZombiesKilled = Int64(self.numberOfZombiesKilled)
        statReview.totalNumberOfCollectibles = Int64(self.totalNumberOfCollectibles)
        statReview.totalValueOfCollectibles = self.totalValueOfCollectibles
        statReview.playerProfile = self.currentPlayerProfile
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error: failed to save game stat data with error \(error.localizedDescription), error \(String(describing: error.localizedFailureReason))")
        }
    }
    
    
    func getAllGameLevelStatReviewsForCurrentPlayerProfile() -> NSSet?{
        
        return currentPlayerProfile.gameSessions
    }
    
    
    func getAllGameLevelStatReviews() -> [GameLevelStatReview]?{
        
        var gameLevelStatReviews: [GameLevelStatReview]?
        
        do {
            
            
            
            gameLevelStatReviews =  try self.managedContext.fetch(self.allGameSessionsFetchRequest)

            
            
        } catch let error as NSError {
            print("Error: unable to load the game level stat reviews with error \(String(describing: error.localizedFailureReason))")
        }
        
        return gameLevelStatReviews
    }
    
    func getGameLevelStatReviewByDate(date: Date) -> [GameLevelStatReview]{
        
        return [GameLevelStatReview]()

    }
    
    func getGameLevelStatReviewByGameLevel(gameLevel: GameLevel) -> [GameLevelStatReview]{
        
        return [GameLevelStatReview]()

    }
    
    
    
    
}
