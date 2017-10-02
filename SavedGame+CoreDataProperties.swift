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
    @NSManaged public var playerProfile: PlayerProfile?

}
