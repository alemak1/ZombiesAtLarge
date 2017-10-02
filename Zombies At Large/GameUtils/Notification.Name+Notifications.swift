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
    static let didActivateCollectibleNotification = "didActivateCollectibleNotification"
    static let didSetOffGrenadeNotification = "didSetOffGrenadeNotification"
    static let didFinishLoadingSceneNotification = "didFinishLoadingSceneNotification"
    static let didRequestBackToMainMenuNotification = "didRequestBackToMainMenuNotification"
    static let didFinishLoadingHUDNotification = "didFinishLoadingHUDNotification"
    
    static func GetDidFinishLoadingHUDNotification() -> Notification.Name{
        return self.init(Notification.Name.didFinishLoadingHUDNotification)
    }
    
    static func GetDidFinishedLoadingSceneNotification() -> Notification.Name{
        return self.init(Notification.Name.didFinishLoadingSceneNotification)
    }
    
    static func GetDidUpdateGameLoadingProgressNotification() -> Notification.Name{
        return self.init(Notification.Name.didUpdateGameLoadingProgressNotification)
    }
    
    static func GetDidRequestBackToMainMenuNotification() -> Notification.Name{
        return self.init(Notification.Name.didRequestBackToMainMenuNotification)

    }
    
    static func GetDidActivateCollectibleNotificationName() -> Notification.Name{
        return self.init(Notification.Name.didActivateCollectibleNotification)
    }
    
    static func GetDidSetOffGrenadeNotificationName() -> Notification.Name{
        return self.init(Notification.Name.didSetOffGrenadeNotification)

    }
}


