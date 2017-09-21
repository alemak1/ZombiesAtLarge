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
            return { return self.requiredCollectibles.count <= 0 }
        case .Level2:
            return { return self.unrescuedCharacters.count <= 0 }
        case .Level3:
            return { return self.player.collectibleManager.getTotalMetalContent() > 200 }
        case .Level4:
            return { return self.mustKillZombies.count <= 0 }
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
                return self.mustKillZombies.count <= 0 && self.unrescuedCharacters.count <= 0
            }
        case .Level8:
            return {
                return self.unrescuedCharacters.count <= 0 && self.requiredCollectibles.count <= 0
            }
        case .Level9:
            return {
                return self.mustKillZombies.count <= 0
            }
        case .Level10:
            return {
                return self.mustKillZombies.count <= 0
            }
        default:
            print("No win condition available for this level ")
        }
        
        return nil
    }
}

