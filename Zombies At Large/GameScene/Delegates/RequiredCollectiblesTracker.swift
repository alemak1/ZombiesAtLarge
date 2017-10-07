//
//  RequiredCollectiblesTracker.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class RequiredCollectiblesTracker: RequiredCollectiblesTrackerDelegate, NSCoding{
    
    
    init() {
        
    }
    
    init(with requiredCollectibles: Set<CollectibleSprite>){
        self.requiredCollectibles = requiredCollectibles
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.requiredCollectibles, forKey: "requiredCollectibles")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.requiredCollectibles = aDecoder.decodeObject(forKey: "requiredCollectibles") as! Set<CollectibleSprite>
    }
    
    var requiredCollectibles: Set<CollectibleSprite> = []
    
    
    var requiredCollectiblesSnapshots: [CollectibleSnapshot]{
        
        return self.requiredCollectibles.enumerated().map({ (idx, reqCollectible) in
            
            return reqCollectible.getSnapshot() as! CollectibleSnapshot
        })
        
        
    }
    
    
    var numberOfRequiredCollectibles: Int{
        return requiredCollectibles.count
    }
    
    func getRequiredCollectibles() -> Set<CollectibleSprite>{
        return requiredCollectibles
    }
    
    func collectibleHasNotBeenAcquired(collectible: CollectibleSprite) -> Bool{
        return self.requiredCollectibles.contains(collectible)
    }
    
    func removeRequiredCollectible(requiredCollectible: CollectibleSprite){
        self.requiredCollectibles.remove(requiredCollectible)

    }
    
    func addRequiredCollectible(requiredCollectible: CollectibleSprite){
        self.requiredCollectibles.insert(requiredCollectible)

    }

}
