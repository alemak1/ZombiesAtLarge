//
//  RequiredCollectiblesTrackerDelegate.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

protocol RequiredCollectiblesTrackerDelegate{
    
    var requiredCollectibles: Set<CollectibleSprite> {set get }
        
    var numberOfRequiredCollectibles: Int{ get }
    
    func removeRequiredCollectible(requiredCollectible: CollectibleSprite)
    
    func addRequiredCollectible(requiredCollectible: CollectibleSprite)

    func getRequiredCollectibles() -> Set<CollectibleSprite>
}
