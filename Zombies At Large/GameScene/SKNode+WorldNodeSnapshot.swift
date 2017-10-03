//
//  SKNode+WorldNodeSnapshot.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


struct WorldNodeSnapshot{
    
   
}

extension SKNode{
    
    func getWorldNodeSnapshot() -> WorldNodeSnapshot{
        
        
        for node in children{
            
            if let node = node as? Zombie{
                
            }
        }
        
        return WorldNodeSnapshot()
    }
    
}
