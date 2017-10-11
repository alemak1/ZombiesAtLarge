//
//  PlayerCollectibleConfiguration+CoreDataClass.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData

@objc(PlayerCollectibleConfiguration)
public class PlayerCollectibleConfiguration: NSManagedObject {

    
    func getRestoredCollectibleFromPlayerCollectibleConfiguration() -> Collectible{
        
        let rawValue = Int(self.collectibleTypeRawValue)
        let cType = CollectibleType(rawValue: rawValue)!
        
        let newCollectible = Collectible(withCollectibleType: cType)
        newCollectible.changeQuantityTo(newQuantity: Int(totalQuantity))
        newCollectible.setCanBeActivatedStatus(to: self.canBeActivated)
        newCollectible.setActivatedStatus(to: self.isActive)
        
        return newCollectible
    }
}
