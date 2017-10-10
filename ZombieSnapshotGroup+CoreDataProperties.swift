//
//  ZombieSnapshotGroup+CoreDataProperties.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData


extension ZombieSnapshotGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZombieSnapshotGroup> {
        return NSFetchRequest<ZombieSnapshotGroup>(entityName: "ZombieSnapshotGroup")
    }

    @NSManaged public var zombieSnapshots: NSSet?

}

// MARK: Generated accessors for zombieSnapshots
extension ZombieSnapshotGroup {

    @objc(addZombieSnapshotsObject:)
    @NSManaged public func addToZombieSnapshots(_ value: ZombieSnapshot)

    @objc(removeZombieSnapshotsObject:)
    @NSManaged public func removeFromZombieSnapshots(_ value: ZombieSnapshot)

    @objc(addZombieSnapshots:)
    @NSManaged public func addToZombieSnapshots(_ values: NSSet)

    @objc(removeZombieSnapshots:)
    @NSManaged public func removeFromZombieSnapshots(_ values: NSSet)

}
