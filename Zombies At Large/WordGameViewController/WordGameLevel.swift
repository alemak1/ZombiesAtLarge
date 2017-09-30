//
//  WordGameLevel.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


enum WordGameLevel: Int{
    
    case Level1 = 1
    case Level2
    case Level3
    case Level4
    case Level5
    
    
    func getNextLevel() -> WordGameLevel{
        
        var nextLevelRawValue: Int = 1
        
        switch self {
        case .Level1,.Level2,.Level3,.Level4:
            nextLevelRawValue = self.rawValue + 1
            break
        default:
            nextLevelRawValue = 1
        }
        
        
        return WordGameLevel(rawValue: nextLevelRawValue)!
    }
    
    func getSKSceneFilename() -> String{
        
        switch self {
        case .Level1:
            return "wordLevelBackgrounds1"
        case .Level2:
            return "wordLevelBackgrounds2"
        case .Level3:
            return "wordLevelBackgrounds3"
        case .Level4:
            return "wordLevelBackgrounds4"
        case .Level5:
            return "wordLevelBackgrounds5"
        default:
            return "wordLevelBackgrounds1"

        }
    }
    
}
