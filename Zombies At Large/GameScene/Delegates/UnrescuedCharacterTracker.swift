//
//  UnrescuedCharacterTracker.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class UnrescuedCharacterTracker: UnrescuedCharacterTrackerDelegate, NSCoding{
    
    
    init() {
        
    }
    
    init(with unrescuedCharacters: Set<RescueCharacter>){
        self.unrescuedCharacters = unrescuedCharacters
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.unrescuedCharacters, forKey: "unrescuedCharacters")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.unrescuedCharacters = aDecoder.decodeObject(forKey: "unrescuedCharacters") as! Set<RescueCharacter>
    }
    
    var unrescuedCharacters: Set<RescueCharacter> = []
    
    
    var unrescuedCharactersSnapshots: [RescueCharacterSnapshot]{
        
        return self.unrescuedCharacters.enumerated().map({ (idx, rescueCharacter) in
            
            return rescueCharacter.getSnapshot() as! RescueCharacterSnapshot
        })
        
        
    }
    
    
    var numberOfUnrescuedCharacters: Int{
        return unrescuedCharacters.count
    }
    
    
    func getUnrescuedCharacters() -> Set<RescueCharacter>{
            return self.unrescuedCharacters
    }
    
    func characterHasNotBeenRescued(character: RescueCharacter) -> Bool{
        return self.unrescuedCharacters.contains(character)
    }
    
    func rescueCharacter(character: RescueCharacter){
        
        if let rescueCharacter = self.unrescuedCharacters.remove(character){
            rescueCharacter.rescueCharacter()
        }
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
