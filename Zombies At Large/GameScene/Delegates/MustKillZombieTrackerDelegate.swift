//
//  MustKillZombieTrackerDelegate.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

protocol MustKillZombieTrackerDelegate{
    
    var mustKillZombies: Set<Zombie> { set get }
    
    var numberOfMustKillZombies: Int{ get }
    
    func getNumberOfUnkilledZombies() -> Int
    
    func addMustKillZombie(zombie: Zombie)
    
    func removeMustKillZombie(withName name: String?)
    
}
