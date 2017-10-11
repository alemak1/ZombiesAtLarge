//
//  SavedGame+CoreDataProperties.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/2/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedGame> {
        return NSFetchRequest<SavedGame>(entityName: "SavedGame")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var level: Int16
    @NSManaged public var frameCount: Double
    @NSManaged public var playerProfile: PlayerProfile?
    @NSManaged public var playerSnapshot: NSObject
    @NSManaged public var zombieSnapshotGroup: ZombieSnapshotGroup?
    @NSManaged public var collectibleSpriteSnapshotGroup: CollectibleSpriteSnapshotGroup?
    @NSManaged public var playerCollectibles: NSSet?
    @NSManaged public var requiredCollectibles: NSSet?
    @NSManaged public var mustKillZombies: NSSet?
    @NSManaged public var unrescuedCharacters: NSSet?
}


