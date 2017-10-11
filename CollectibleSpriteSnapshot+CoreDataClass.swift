//
//  CollectibleSpriteSnapshot+CoreDataClass.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData
import UIKit

@objc(CollectibleSpriteSnapshot)
public class CollectibleSpriteSnapshot: NSManagedObject {

    
    func getCollectibleSpriteSnapshotDebugString() -> String{
        
        let pos = position as! CGPoint
        
        return "Collectible Sprite Information ---> Required status: \(self.isRequired ? "required" : "not required"); Collectible Type: \(self.collectibleTypeRawValue) at position: x \(pos.x), y \(pos.y)"
    }
    
    func getCollectibleSpriteRestoredFromSnapshot() -> CollectibleSprite{
        
        let collectibleType = CollectibleType(rawValue: Int(self.collectibleTypeRawValue))!
        let newCollectibleSprite = CollectibleSprite(collectibleType: collectibleType, scale: 1.00)
        newCollectibleSprite.isRequired = self.isRequired
        newCollectibleSprite.position = self.position as! CGPoint
        
        return newCollectibleSprite
    }
}
