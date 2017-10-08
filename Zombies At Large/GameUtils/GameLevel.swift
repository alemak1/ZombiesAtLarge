//
//  GameLevel.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit

/** The GameScene has a GameLevel stored property, whose value determines which backgrounds to load, the informatin displayed in UI panels at the start of each level, and the game objective for each level, which is evaluated in the update function via a switch statement **/

/** Objectives for different game levels include: obtaining certain collectibles (getting all the tools), getting a certain level of metal content, gettinga  certain monetary value for all collectibles, destroying certain collectibles (central processor), killing all the zombies, killing zombies while protecting innocent bystanders
 **/

enum GameLevel: Int{
    case Level1 = 1, Level2, Level3, Level4, Level5
    case Level6, Level7, Level8, Level9, Level10
    
    
    static let AllGameLevels: [GameLevel] = [
    
        .Level1, .Level2, .Level3, .Level4, .Level5
    ]
    
    func getNextLevel() -> GameLevel{
        
        switch self {
        case .Level1,.Level2,.Level3,.Level4,.Level5,.Level6,.Level7,.Level8,.Level9:
            let rawValueNext = self.rawValue + 1
            return GameLevel(rawValue: rawValueNext)!
        case .Level10:
            return .Level1
        default:
            break
        }
    }
    
    func getFullGameMissionDescription() -> String{
        switch self {
        case .Level1:
            return "Help scientists cure the zombie virus.  Find all the microscopes."
        default:
            return "Kill the zombies!"
        }
    }
    
    func getSKSceneFilename() -> String{
        switch self {
        case .Level1:
            return "backgrounds"
        case .Level2:
            return "backgrounds2"
        case .Level3:
            return "backgrounds3"
        case .Level4:
            return "backgrounds4"
        case .Level5:
            return "backgrounds5"
        default:
            return "backgrounds"
        }
    }
    
    func getMissionHeaderText() -> (title: String,subtitle: String){
        switch self {
        case .Level1:
            return ("Mission 1:","Microscope Recovery")
        case .Level2:
            return ("Mission 2:","Save the Old Ladies")
        case .Level3:
            return ("Mission 3:","Accumulate metal")
        case .Level4:
            return ("Mission 4:","Kill the red zombies")
        case .Level5:
            return ("Mission 5:","Save money")

        default:
            return (String(),String())
        }
    }
    
    
    func getMustKillZombieType() -> Updateable.Type{
        switch self {
        case .Level4:
            return GiantZombie.self
        default:
            return GiantZombie.self
        }
    }
    
    func getNumberOfMustKillZombies() -> Int{
        switch self {
        case .Level4:
            return 5
        default:
            return 0
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
    
    func getRescueCharacterType() -> NonplayerCharacterType{
        switch self{
        case .Level2:
            return .OldWoman
        case .Level3:
            return .GreenWoman
        default:
            return .GreenWoman
        }
    }
    
    func getNumberOfUnrescuedCharacter() -> Int{
        switch self {
        case .Level1:
            return 6
        case .Level2:
            return 3
        default:
            return 0
        }
    }
    
    func getNumberOfRequiredCollectibles() -> Int{
        switch self {
        case .Level1:
            return 7
        default:
            return 0
        }
    }
    
    func getLevelThumbnail() -> UIImage{
        
        switch self {
        case .Level1:
            return #imageLiteral(resourceName: "defaultLevelThumbnail")
        case .Level2:
            return #imageLiteral(resourceName: "level2")
        case .Level3:
            return #imageLiteral(resourceName: "level3")
        case .Level4:
            return #imageLiteral(resourceName: "level4")
        case .Level5:
            return #imageLiteral(resourceName: "level5")
        default:
            return #imageLiteral(resourceName: "defaultLevelThumbnail")
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
        case .Level2:
            return ("Save all of","the little old","ladies.","","")
        case .Level3:
            return ("Obtain total","metal content of","over 200 kg.","","")
        case .Level4:
            return ("Kill all of","the red zombies.","","","")
        case .Level5:
            return ("Get $2000 worth","of collectibles","","","")
        default:
            return (String(),String(),String(),String(),String())
        }
        
        return (String(),String(),String(),String(),String())
    }
    
  
    
    
  
    
    
    
    
    
}
