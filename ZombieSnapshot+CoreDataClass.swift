//
//  ZombieSnapshot+CoreDataClass.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import SpriteKit
import CoreData

@objc(ZombieSnapshot)
public class ZombieSnapshot: NSManagedObject {

    
    func getZombieInformation() -> String{
        
        let wPosition = position as! CGPoint
        
        return "Zombie located at position x: \(wPosition.x), y: \(wPosition.y) with health level of \(currentHealth) and damage status of: \(isDamaged ? "damaged":"not damaged") and current frameCount of \(frameCount) and zombie type of \(zombieTypeRawValue)"
    }
    
    
    func getZombieRestoredFromZombieSnapshot() -> Zombie{
        
        
        let zombieType = ZombieType(rawValue: self.zombieTypeRawValue!)!
        let reloadedZombie = Zombie(zombieType: zombieType)
        
        reloadedZombie.currentHealth = Int(self.currentHealth)
        reloadedZombie.currentMode = Zombie.ZombieMode(rawValue: Int(self.currentModeRawValue))!
        
        reloadedZombie.frameCount = self.frameCount
        reloadedZombie.isDamaged =  self.isDamaged
        reloadedZombie.shootingFrameCount = self.shootingFrameCount
        reloadedZombie.position = self.position as! CGPoint
        
        return reloadedZombie

    }
}
