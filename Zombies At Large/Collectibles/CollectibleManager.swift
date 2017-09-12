//
//  CollectibleManager.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/11/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class CollectibleManager{
    
    var collectibles = Set<Collectible>()
    var carryingCapacity: Double = 300.00
    
    
    init(){
        
    }
    
    
    func addCollectibleItem(newCollectible collectible: Collectible, andWithQuantityOf quantity: Int = 1){
        
        if(self.getTotalMassOfAllCollectibles() + collectible.getCollectibleMass() > self.carryingCapacity){
            
            print("Failed to add item: player does not have the carrying capacity to add this item")
            return;
        }
        
        
        if let existingCollectible = collectibles.remove(collectible){
            
            let originalQty = existingCollectible.getQuantityOfCollectible()
            
            existingCollectible.changeQuantityTo(newQuantity: originalQty + quantity)

            collectibles.insert(existingCollectible)
            
        } else {
            collectibles.insert(collectible)
        }
        
        
        
        
    }
    
    
    func hasItem(collectible: Collectible) -> Bool{
        
        return self.collectibles.contains(collectible)
    
    }
    
    func getTotalMonetaryValueOfAllCollectibles() -> Double{
        
        if collectibles.isEmpty{
            return 0.00
        }
        
        return self.collectibles.map({ return $0.getCollectibleMonetaryValue() }).reduce(0.00){ $0 + $1 }
        
    }
    
    func getTotalMassOfAllCollectibles() -> Double {
        
        if collectibles.isEmpty{
            return 0.00
        }
        
        return self.collectibles.map({  return $0.getCollectibleMass() }).reduce(0.00){$0+$1}
        
    }
    
    func getTotalMetalContent() -> Double{
        
        if collectibles.isEmpty{
            return 0.00
        }
        
        return self.collectibles.map({ return $0.getCollectibleMetalContent() }).reduce(0.00){$0+$1}
    }
    
    func getTotalNumberOfItems() -> Int{
        return collectibles.count
    }
    
    
    func hasExceededCarryingCapacity() -> Bool{
        
        return getTotalMassOfAllCollectibles() > self.carryingCapacity
    }
    
    
}
