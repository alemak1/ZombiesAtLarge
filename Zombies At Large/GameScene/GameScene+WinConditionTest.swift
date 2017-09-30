//
//  GameScene+WinConditionTest.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


extension GameScene{
    
    func getWinConditionTest() -> (() -> Bool)?{
        
        switch self.currentGameLevel! {
        case .Level1:
            return {
                
                guard let requiredCollectiblesTracker = self.requiredCollectiblesTrackerDelegate else {
                    fatalError("Error: found nil while unwrapping the required collectibles tracker delegate")
                }
                
                return requiredCollectiblesTracker.numberOfRequiredCollectibles <= 0
                
            }
        case .Level2:
            
            guard let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate else {
                fatalError("Error: found nil while unwrapping the unrescued characters tracker delegate")
                
            }
            return { return unrescuedCharactersTracker.numberOfUnrescuedCharacters <= 0 }
        case .Level3:
            return { return self.player.collectibleManager.getTotalMetalContent() > 200 }
        case .Level4:
            return {
                
                guard let zombieTracker = self.mustKillZombieTrackerDelegate else {
                    fatalError("Error: found nil while attempting to unwrap the must kill zombie tracker delegate")
                }
                
                return zombieTracker.getNumberOfUnkilledZombies() <= 0
                
            }
        case .Level5:
            return { return self.player.collectibleManager.getTotalMonetaryValueOfAllCollectibles() > 2000 }
        case .Level6:
            return {
                
                guard let destinationZone = self.destinationZone else {
                    fatalError("No destination zone initialized for this level")
                }
                
                return destinationZone.contains(self.player.position)
                
            }
        case .Level7:
            return {
                
                guard let zombieTracker = self.mustKillZombieTrackerDelegate else {
                    fatalError("Error: found nil while attempting to unwrap the must kill zombie tracker delegate")
                }
                
                guard let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate else {
                    fatalError("Error: found nil while unwrapping the unrescued characters tracker delegate")
                    
                }
                
                return zombieTracker.getNumberOfUnkilledZombies() <= 0 && unrescuedCharactersTracker.numberOfUnrescuedCharacters <= 0
            }
        case .Level8:
            return {
                
                guard let requiredCollectiblesTracker = self.requiredCollectiblesTrackerDelegate else {
                    fatalError("Error: found nil while unwrapping the required collectibles tracker delegate")
                }
                
                guard let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate else {
                    fatalError("Error: found nil while unwrapping the unrescued characters tracker delegate")

                }
                
                return unrescuedCharactersTracker.numberOfUnrescuedCharacters <= 0 && requiredCollectiblesTracker.numberOfRequiredCollectibles <= 0
            }
        case .Level9:
            return {
                
                guard let zombieTracker = self.mustKillZombieTrackerDelegate else {
                    fatalError("Error: found nil while attempting to unwrap the must kill zombie tracker delegate")
                }
                
                return zombieTracker.getNumberOfUnkilledZombies() <= 0
            }
        case .Level10:
            return {
                
                guard let zombieTracker = self.mustKillZombieTrackerDelegate else {
                    fatalError("Error: found nil while attempting to unwrap the must kill zombie tracker delegate")
                }
                
                return zombieTracker.getNumberOfUnkilledZombies() <= 0
            }
        default:
            print("No win condition available for this level ")
        }
        
        return nil
    }
}

