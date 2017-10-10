//
//  SKNode+WorldNodeSnapshot.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


/** Extension to SKNode provides convenience methods for obtaining a snapshot of the world node for the game scene; the world node snapshot can be saved as part of an overall Game Scene snapshot so as to allow for relevant game scene data to be archived and unarchived efficently **/

struct WorldNodeConfiguration{
    var zombieConfigurations: [ZombieConfiguration]
    var collectibleSpriteConfigurations: [CollectibleSpriteConfiguration]
}


extension SKNode{
    
    func getWorldNodeConfiguration() -> WorldNodeConfiguration{
        
        var zombieConfigurations = [ZombieConfiguration]()
        var collectibleSpriteConfigurations = [CollectibleSpriteConfiguration]()
        
        for node in children{
            if let node = node as? Zombie{
                zombieConfigurations.append(node.getZombieConfiguration())
            }
            
            if let node = node as? CollectibleSprite{
                collectibleSpriteConfigurations.append(node.getCollectibleSpriteConfiguration())
            }
        }
        
        return WorldNodeConfiguration(zombieConfigurations: zombieConfigurations, collectibleSpriteConfigurations: collectibleSpriteConfigurations)
    }
    
    
    
}
