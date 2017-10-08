//
//  GameLevelStatReview+CoreDataProperties.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//
//

import Foundation
import CoreData


extension GameLevelStatReview {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameLevelStatReview> {
        return NSFetchRequest<GameLevelStatReview>(entityName: "GameLevelStatReview")
    }

    @NSManaged public var gameLevel: Int64
    @NSManaged public var date: NSDate?
    @NSManaged public var numberOfZombiesKilled: Int64
    @NSManaged public var numberOfBulletsFired: Int64
    @NSManaged public var totalValueOfCollectibles: Double
    @NSManaged public var totalNumberOfCollectibles: Int64
    @NSManaged public var totalMoney: Double
    @NSManaged public var replayVideo: NSData?
    @NSManaged public var playerProfile: PlayerProfile

}
