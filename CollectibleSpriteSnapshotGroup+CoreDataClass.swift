//
//  CollectibleSpriteSnapshotGroup+CoreDataClass.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData

@objc(CollectibleSpriteSnapshotGroup)
public class CollectibleSpriteSnapshotGroup: NSManagedObject {

    func showCollectibleSpriteSnapshotGroupDebugInfo(){
        
        let cSnapshots = self.collectibleSpriteSnapshots!.allObjects as! [CollectibleSpriteSnapshot]
        
        let debugStr = cSnapshots.map({$0.getCollectibleSpriteSnapshotDebugString()}).reduce("", {"\($0) \n \($1)"})
        
        print(debugStr)
        
    }
}
