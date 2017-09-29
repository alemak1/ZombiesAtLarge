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

class GameLevelStatTracker{
    
    
    var gameLevel: GameLevel
     var date = Date()
     var numberOfZombiesKilled: Int = 0
     var numberOfBulletsFired: Int = 0
     var totalValueOfCollectibles: Double = 0
     var totalNumberOfCollectibles: Int = 0
    
    lazy var allGameSessionsFetchRequest: NSFetchRequest<GameLevelStatReview> = {
        
        let fetchRequest = NSFetchRequest<GameLevelStatReview>(entityName: "GameLevelStatReview")
        
        return fetchRequest
    }()
    
    
    init(gameLevel: GameLevel) {
        self.gameLevel = gameLevel
    }
    
    
    private var managedContext: NSManagedObjectContext{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: failed to load the app delegate from the GameLevelStat Tracker")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    private var entityDescription: NSEntityDescription{
        return NSEntityDescription.entity(forEntityName: "GameLevelStatReview", in: self.managedContext)!
    }
    
    func saveGameLevelStats(){

        let statReview = GameLevelStatReview(entity: self.entityDescription, insertInto: self.managedContext)
        
        statReview.date = self.date as NSDate
        statReview.gameLevel = Int16(self.gameLevel.rawValue)
        statReview.numberOfBulletsFired = Int64(self.numberOfBulletsFired)
        statReview.numberOfZombiesKilled = Int64(self.numberOfZombiesKilled)
        statReview.totalNumberOfCollectibles = Int64(self.totalNumberOfCollectibles)
        statReview.totalValueOfCollectibles = self.totalValueOfCollectibles
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error: failed to save game stat data with error \(error.localizedDescription), error \(String(describing: error.localizedFailureReason))")
        }
    }
    
    
    func getAllGameLevelStatReviews() -> [GameLevelStatReview]?{
        
        var gameLevelStatReviews: [GameLevelStatReview]?
        
        do {
            
            gameLevelStatReviews = try self.managedContext.fetch(self.allGameSessionsFetchRequest)
            
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
