//
//  CollectibleSpriteSnapshotGroup+CoreDataProperties.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData


extension CollectibleSpriteSnapshotGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectibleSpriteSnapshotGroup> {
        return NSFetchRequest<CollectibleSpriteSnapshotGroup>(entityName: "CollectibleSpriteSnapshotGroup")
    }

    @NSManaged public var collectibleSpriteSnapshots: NSSet?

}

// MARK: Generated accessors for collectibleSpriteSnapshots
extension CollectibleSpriteSnapshotGroup {

    @objc(addCollectibleSpriteSnapshotsObject:)
    @NSManaged public func addToCollectibleSpriteSnapshots(_ value: CollectibleSpriteSnapshot)

    @objc(removeCollectibleSpriteSnapshotsObject:)
    @NSManaged public func removeFromCollectibleSpriteSnapshots(_ value: CollectibleSpriteSnapshot)

    @objc(addCollectibleSpriteSnapshots:)
    @NSManaged public func addToCollectibleSpriteSnapshots(_ values: NSSet)

    @objc(removeCollectibleSpriteSnapshots:)
    @NSManaged public func removeFromCollectibleSpriteSnapshots(_ values: NSSet)

}
