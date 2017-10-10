//
//  CollectibleSpriteSnapshot+CoreDataProperties.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData


extension CollectibleSpriteSnapshot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectibleSpriteSnapshot> {
        return NSFetchRequest<CollectibleSpriteSnapshot>(entityName: "CollectibleSpriteSnapshot")
    }

    @NSManaged public var collectibleTypeRawValue: Int32
    @NSManaged public var position: NSObject?
    @NSManaged public var isRequired: Bool
    @NSManaged public var collectibleSpriteSnapshotGroup: CollectibleSpriteSnapshotGroup?
}
