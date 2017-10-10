//
//  PlayerCollectibleConfiguration+CoreDataProperties.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData


extension PlayerCollectibleConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerCollectibleConfiguration> {
        return NSFetchRequest<PlayerCollectibleConfiguration>(entityName: "PlayerCollectibleConfiguration")
    }

    @NSManaged public var collectibleTypeRawValue: Int64
    @NSManaged public var totalQuantity: Int64
    @NSManaged public var canBeActivated: Bool
    @NSManaged public var isActive: Bool
    @NSManaged public var savedGame: SavedGame
    

}
