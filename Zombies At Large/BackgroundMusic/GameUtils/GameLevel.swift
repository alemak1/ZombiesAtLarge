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
    
        .Level1, .Level2, .Level3, .Level4, .Level5, .Level6, .Level7, .Level8, .Level9, .Level10
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
        case .Level2:
            return "Save all of the retired baby-boomer grandmas. Only they remember how the infection started"
        case .Level3:
            return "Zombie anti-virus researchers need to build a lab. Obtain total metal content of over 200 kg."
        case .Level4:
            return "A new breed of mutant zombies has been spawned. Find them and eliminate them."
        case .Level5:
            return "Funding for the anti-virus research lab is still lacking. Get $2000 worth of collectibles"
        case .Level6:
            return "The zombie-virus researchers are in trouble. Find the scientists and take all them to the safety zone."
        case .Level7:
            return "The anti-virus formula data is stored on secret memory cards. Find all of the memory chips"
        case .Level8:
            return "You have found the memory cards. Now quickly go to the research station."
        case .Level9:
            return "The zombie virus has been cured. Find and collect all of the red pills."
        case .Level10:
            return "The zombie virus is mutating. Kill at least 20 zombies to ensure the virus is gone."
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
        case .Level6:
            return "backgrounds6"
        case .Level7:
            return "backgrounds7"
        case .Level8:
            return "backgrounds8"
        case .Level9:
            return "backgrounds9"
        case .Level10:
            return "backgrounds10"
        default:
            return "backgrounds"
        }
    }
    
    func getMissionHeaderText() -> (title: String,subtitle: String){
        switch self {
        case .Level1:
            return ("Mission 1:","Microscope Recovery")
        case .Level2:
            return ("Mission 2:","Save the Survivors")
        case .Level3:
            return ("Mission 3:","Accumulate metal")
        case .Level4:
            return ("Mission 4:","Kill the red zombies")
        case .Level5:
            return ("Mission 5:","Save money")
        case .Level6:
            return ("Mission 6:","Rescue the Scientists")
        case .Level7:
            return ("Mission 7:","Memory Chips")
        case .Level8:
            return ("Mission 8:","Go to the Research Station")
        case .Level9:
            return ("Mission 9:","Zombie Antidote")
        case .Level10:
            return ("Mission 10:","Zombies' Last Stand")
        }
    }
    
    
    func getMustKillZombieType() -> Updateable.Type{
        switch self {
        case .Level4:
            return GiantZombie.self
        case .Level10:
            return CamouflageZombie.self
        default:
            return MiniZombie.self
        }
    }
    
    func getNumberOfMustKillZombies() -> Int{
        switch self {
        case .Level4:
            return 5
        case .Level10:
            return 4
        default:
            return 0
        }
    }
    
    
    func getRequiredCollectibleType() -> CollectibleType?{
        switch self {
        case .Level1:
            return CollectibleType.Microscope
        case .Level7:
            return CollectibleType.RAMStick2
        case .Level9:
            return CollectibleType.RedPills
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
        case .Level6:
            return .Survivor1
        default:
            return .GreenWoman
        }
    }

    func getNumberOfUnrescuedCharacter() -> Int{
        switch self {
        case .Level1:
            return 6
        case .Level2:
            return 6
        case .Level6:
            return 15
        default:
            return 0
        }
    }
    
    func getNumberOfRequiredCollectibles() -> Int{
        switch self {
        case .Level1:
            return 7
        case .Level7:
            return 5
        case .Level9:
            return 10
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
            return ("Save all of","the retired",
                    "baby-boomer grandmas.",
                    "Only they remember",
                    "how the infection started")
        case .Level3:
            return ("Zombie anti-virus researchers",
                    "need to build a lab.",
                    "Obtain total.","metal content of","over 200 kg")
        case .Level4:
            return ("A new breed of",
                    "mutant zombies",
                    "has been spawned.",
                    "Find them",
                    "and eliminate them.")
        case .Level5:
            return ("Funding for the",
                    "anti-virus research lab",
                    "is still lacking",
                    "Get $2000 worth",
                    "of collectibles")
        case .Level6:
            return ("The zombie-virus researchers",
                    "are in trouble.",
                    "Find the scientists",
                    "and take all of them",
                    "to the safety zone.")
        case .Level7:
            return ("The anti-virus formula",
                    "data is stored",
                    "on secret memory cards.",
                    "Find all of",
                    "the memory chips.")
        case .Level8:
            return ("You have found",
                    "the memory cards.",
                    "Now quickly",
                    "to the",
                    "research station.")
        case .Level9:
            return ("The zombie virus",
                    "has been cured.",
                    "Find and collect",
                    "all of the",
                    "red pills.")
        case .Level10:
            return ("The zombie virus",
                    "is mutating.",
                    "Kill at least 20",
                    "zombies to ensure",
                    "the virus is gone.")

        }
        
    }
    
  
    
    func getBackgroundMusicFileName()->String{
        switch self {
        case .Level1:
            return "Retro Mystic.mp3"
        case .Level2:
            return "Retro Comedy.mp3"
        case .Level3:
            return "Retro Reggae.mp3"
        case .Level4:
            return "Retro Beat.mp3"
        case .Level5:
            return "Retro Polka.mp3"
        case .Level6:
            return "Retro Mystic.mp3"
        case .Level7:
            return "Retro Comedy.mp3"
        case .Level8:
            return "Retro Beat.mp3"
        case .Level9:
            return "Retro Comedy.mp3"
        case .Level10:
            return "Retro Mystic.mp3"
        default:
            return "Retro Mystic.mp3"
        }
    }
  
    
    
    
    
    
}
