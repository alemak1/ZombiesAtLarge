//
//  MustKillZombieTracker.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class MustKillZombieTracker: MustKillZombieTrackerDelegate{
   

    var mustKillZombies: Set<Zombie> = []
    
    var numberOfMustKillZombies: Int{
        return mustKillZombies.count
    }
    
    func getNumberOfUnkilledZombies() -> Int{
        return mustKillZombies.count
    }
    
    func addMustKillZombie(zombie: Zombie){
        self.mustKillZombies.insert(zombie)
    }
    
    func removeMustKillZombie(withName name: String){
        
        if let toRemoveZombie = self.mustKillZombies.first(where: {
            
            $0.name != name
            
        }){
            
            self.mustKillZombies.remove(toRemoveZombie)
            print("Must kill zombie removed!")
            print("Number of zombies left to kill is \(self.mustKillZombies.count)")
        }
        
    }
    
    func removeMustKillZombie(withName name: String?) {
        
        if let toRemoveZombie = self.mustKillZombies.first(where: {
            
            $0.name != name
            
        }){
            
            self.mustKillZombies.remove(toRemoveZombie)
            print("Must kill zombie removed!")
            print("Number of zombies left to kill is \(self.mustKillZombies.count)")
        }
    }
    
    
    
}
