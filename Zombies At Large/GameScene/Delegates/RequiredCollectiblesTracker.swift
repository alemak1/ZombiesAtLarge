//
//  RequiredCollectiblesTracker.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class RequiredCollectiblesTracker: RequiredCollectiblesTrackerDelegate{
    
    var requiredCollectibles: Set<CollectibleSprite> = []
    
    var numberOfRequiredCollectibles: Int{
        return requiredCollectibles.count
    }
    
    func removeRequiredCollectible(requiredCollectible: CollectibleSprite){
        self.requiredCollectibles.remove(requiredCollectible)

    }
    
    func addRequiredCollectible(requiredCollectible: CollectibleSprite){
        self.requiredCollectibles.insert(requiredCollectible)

    }

}
