//
//  RescueCharConfiguration+CoreDataProperties.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData


extension RescueCharConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RescueCharConfiguration> {
        return NSFetchRequest<RescueCharConfiguration>(entityName: "RescueCharConfiguration")
    }

    @NSManaged public var hasBeenRescued: Bool
    @NSManaged public var nonplayerTypeCharacter: Int64
    @NSManaged public var compassDirectionRawValue: Int64
    @NSManaged public var savedGame: SavedGame?

}
