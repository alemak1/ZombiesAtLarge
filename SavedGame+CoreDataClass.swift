//
//  SavedGame+CoreDataClass.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/2/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SavedGame)
public class SavedGame: NSManagedObject {

    func getFormattedDateString() -> String{
        
        guard let date = self.date as Date? else {
            return "No Date Recorded"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    
    
    func showSavedGameInfo(){
        
        let dateString = getFormattedDateString()
        let gameLevel = Int(self.level)
        
        let playerName = self.playerProfile?.name
        
        let pSnapshot = self.playerSnapshot as! PlayerStateSnapShot
        
        let numberOfUniqueItems = pSnapshot.collectibleManager.getTotalNumberOfUniqueItems()
        let numberOfAllItems = pSnapshot.collectibleManager.getTotalNumberOfAllItems()
        let totalValueOfCollectibles = pSnapshot.collectibleManager.getTotalMonetaryValueOfAllCollectibles()
        let numberOfBullets = pSnapshot.numberOfBullets
        let health = pSnapshot.healthLevel
        let position = pSnapshot.position
        
        print("Saved Game for Date: \(dateString), Game Level: \(gameLevel), for Player Name: \(playerName), with health of \(health), total bullets remaining of \(numberOfBullets), and at position x: \(position.x) and y: \(position.y), with total unique items of \(numberOfUniqueItems), total collectibles of \(numberOfAllItems), and total value of all collectibles \(totalValueOfCollectibles)")
        
        print("The Game Scene collectibles are as follows: ")
        
        let csSnapshots = self.collectibleSpriteSnapshotGroup?.collectibleSpriteSnapshots?.allObjects as! [CollectibleSpriteSnapshot]
        
        csSnapshots.forEach({
            print($0.getCollectibleSpriteSnapshotDebugString())
        })
        
        print("The game scene zombies have the following information: ")
        
        let zSnapshots = self.zombieSnapshotGroup?.zombieSnapshots?.allObjects as! [ZombieSnapshot]
        
        zSnapshots.forEach({
            print($0.getZombieInformation())
        })
        
        print(self.requiredCollectibles.debugDescription)
        print(self.mustKillZombies.debugDescription)
        print(self.unrescuedCharacters.debugDescription)
        
        print(self.frameCount)
        
       
        
        
    }
}
