//
//  PlayerProfile+CoreDataProperties.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//
//

import Foundation
import CoreData


extension PlayerProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerProfile> {
        return NSFetchRequest<PlayerProfile>(entityName: "PlayerProfile")
    }

    @NSManaged public var dateCreated: NSDate
    @NSManaged public var name: String
    @NSManaged public var playerType: Int64
    @NSManaged public var specialWeapon: Int64
    @NSManaged public var upgradeCollectible: Int64
    @NSManaged public var gameSessions: NSSet?
    @NSManaged public var savedGames: NSSet?

}

// MARK: Generated accessors for gameSessions
extension PlayerProfile {

    @objc(addGameSessionsObject:)
    @NSManaged public func addToGameSessions(_ value: GameLevelStatReview)

    @objc(removeGameSessionsObject:)
    @NSManaged public func removeFromGameSessions(_ value: GameLevelStatReview)

    @objc(addGameSessions:)
    @NSManaged public func addToGameSessions(_ values: NSSet)

    @objc(removeGameSessions:)
    @NSManaged public func removeFromGameSessions(_ values: NSSet)

}
