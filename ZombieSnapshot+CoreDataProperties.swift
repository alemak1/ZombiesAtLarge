//
//  ZombieSnapshot+CoreDataProperties.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData


extension ZombieSnapshot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZombieSnapshot> {
        return NSFetchRequest<ZombieSnapshot>(entityName: "ZombieSnapshot")
    }

    @NSManaged public var currentHealth: Int64
    @NSManaged public var currentModeRawValue: Int64
    @NSManaged public var frameCount: Double
    @NSManaged public var isActive: Bool
    @NSManaged public var isDamaged: Bool
    @NSManaged public var position: NSObject?
    @NSManaged public var shootingFrameCount: Double
    @NSManaged public var zombieTypeRawValue: String?
    @NSManaged public var zombieSnapshotGroup: ZombieSnapshotGroup?
    @NSManaged public var specialType: Int64
    
}
