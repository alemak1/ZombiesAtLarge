//
//  MustKillZombieTracker.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit



class MustKillZombieTracker: MustKillZombieTrackerDelegate, NSCoding{
   
    
    init() {
        
    }
    
    init(withMustKillZombies mustKillZombies: Set<Zombie>){
        self.mustKillZombies = mustKillZombies
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.mustKillZombies, forKey: "mustKillZombies")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.mustKillZombies = aDecoder.decodeObject(forKey: "mustKillZombies") as! Set<Zombie>
    }
    
    
    var mustKillZombies: Set<Zombie> = []
    
    var mustKillZombiesSnapshots: [ZombieSnapshot]{
        
        return self.mustKillZombies.enumerated().map({ (idx, zombie) in
            
            return zombie.getSnapshot() as! ZombieSnapshot
        })
        

    }
    
    var numberOfMustKillZombies: Int{
        return mustKillZombies.count
    }
    
    func getNumberOfUnkilledZombies() -> Int{
        return mustKillZombies.count
    }
    
    
    func getMustKillZombies() -> Set<Zombie>{
        return mustKillZombies
    }
    
    func addMustKillZombie(zombie: Zombie){
        self.mustKillZombies.insert(zombie)
    }
    
    
    
    func zombieHasNotBeenKilled(zombie: Zombie) -> Bool{
        
        return self.mustKillZombies.contains(zombie)
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
