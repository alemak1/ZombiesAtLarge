//
//  UnrescuedCharacterTracker.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class UnrescuedCharacterTracker: UnrescuedCharacterTrackerDelegate{
    
    var unrescuedCharacters: Set<RescueCharacter> = []
    
    var numberOfUnrescuedCharacters: Int{
        return unrescuedCharacters.count
    }
    
    func constraintRescuedCharactersToPlayer(){
        for rescueCharacter in self.unrescuedCharacters{
            rescueCharacter.constrainToPlayer()
            
        }
    }
    
    
    
    func checkSafetyZoneForRescueCharacterProximity(safetyZone: SKSpriteNode){
        for rescueCharacter in self.unrescuedCharacters{
            if safetyZone.contains(rescueCharacter.position){
                
                print("The rescue character has entered the safety zone... Proceeding to remove the rescue character from the array of rescue character")
                
                self.unrescuedCharacters.remove(rescueCharacter)
                
                print("The current number of unrescued character is \(self.unrescuedCharacters.count)")
            }
        }
    }
    
    func addUnrescuedCharacters(rescueCharacter: RescueCharacter){
         self.unrescuedCharacters.insert(rescueCharacter)
    }
    
    func removeUnrescuedCharacter(rescueCharacter: RescueCharacter){
        self.unrescuedCharacters.remove(rescueCharacter)

    }
    
}
