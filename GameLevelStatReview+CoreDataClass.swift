//
//  GameLevelStatReview+CoreDataClass.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GameLevelStatReview)
public class GameLevelStatReview: NSManagedObject {

    func getFormattedDateString() -> String{
        
        guard let date = self.date as Date? else {
            return "No Date Recorded"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    func showGameLevelStatReviewSummary(){
        
        let dateString = getFormattedDateString()
    
        print("Game Session Date: \(dateString) for Game Session \(Int(self.gameLevel))")
        print("Number of Zombies Killed: \(Int(self.numberOfZombiesKilled))")
        print("Number of Bullets Fired: \(Int(self.numberOfBulletsFired))")
        print("Total Value of All Collectibles: \(self.totalValueOfCollectibles)")
        print("Total Number of All Collectibles: \(self.totalNumberOfCollectibles)")
        
    }
}
