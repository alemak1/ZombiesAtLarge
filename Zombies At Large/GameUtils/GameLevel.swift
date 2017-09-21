//
//  GameLevel.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

/** The GameScene has a GameLevel stored property, whose value determines which backgrounds to load, the informatin displayed in UI panels at the start of each level, and the game objective for each level, which is evaluated in the update function via a switch statement **/

/** Objectives for different game levels include: obtaining certain collectibles (getting all the tools), getting a certain level of metal content, gettinga  certain monetary value for all collectibles, destroying certain collectibles (central processor), killing all the zombies, killing zombies while protecting innocent bystanders
 **/

enum GameLevel: Int{
    case Level1 = 1, Level2, Level3, Level4, Level5
    case Level6, Level7, Level8, Level9, Level10
    
    
    func getMissionHeaderText() -> (title: String,subtitle: String){
        switch self {
        case .Level1:
            return ("Mission 1:","Microscope Recovery")
        default:
            return (String(),String())
        }
    }
    
    
    func getRequiredCollectibleType() -> CollectibleType?{
        switch self {
        case .Level1:
            return CollectibleType.Microscope
        default:
            return nil
        }
    }
    
    func getNumberOfRequiredCollectibles() -> Int{
        switch self {
        case .Level1:
            return 5
        default:
            return 0
        }
    }

    
    func getMissionBodyText() -> (String,String,String,String,String){
        switch self {
        case .Level1:
            return ("Find all of",
                    "the microscopes",
                    "Help scientists",
                    "find a cure for",
                    "the Zombie virus."
                    )
            
        default:
            return (String(),String(),String(),String(),String())
        }
        
    }
    
  
    
    
  
    
    
    
    
    
}
