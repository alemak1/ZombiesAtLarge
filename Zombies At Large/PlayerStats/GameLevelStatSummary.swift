//
//  GameLevelStatSummary.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


struct GameLevelStatInfo{
    
    static let kNumberOfZombiesKilled = "numberOfZombiesKilled"
    static let kNumberOfBulletsFired = "numberOfBulletsFired"
    static let kTotalValueOfCollectibles = "totalValueOfCollectibles"
    static let kTotalNumberOfCollectibles = "totalNumberOfCollectibles"

    var numberOfZombiesKilled: Int
    var numberOfBulletsFired: Int
    var totalValueOfCollectibles: Double
    var totalNumberOfCollectibles: Int
    
  
}
