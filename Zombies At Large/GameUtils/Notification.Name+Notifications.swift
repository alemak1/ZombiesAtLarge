//
//  Notification.Name+Notifications.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

extension Notification.Name{
    static let RescueCharacterHasReachedSafetyZoneNotification = "rescueCharacterHasReachedSafetyZoneNotification"
    static let ShowInventoryCollectionViewNotification = "showInventoryCollectionViewNotification"
    static let didUpdateGameLoadingProgressNotification = "didUpdateGameLoadingProgressNotification"
    static let didMakeProgressTowardsGameLoadingNotification = "didMakeProgressTowardsGameLoadingNotification"
   static let didKillMustKillZombieNotification = "didKillMustKillZombieNotification"
}

