//
//  GameScene+UIPanelManager.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/22/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


extension GameScene{
    
    
    public func showCameraZombiePrompt(){
        
        if let cameraPrompt = UIPanelGenerator.GetCameraZombiePrompt(){
            
            cameraPrompt.move(toParent: overlayNode)
            cameraPrompt.position = CGPoint.zero
            
            isPaused = true
            worldNode.isPaused = true
            
        } else {
            print("Error: Failed to load the mission completed prompt")
        }
        
    }
    
    
    public func showMerchantPrompt(){
        if let traderPrompt = UIPanelGenerator.GetTraderPrompt(){
            
            traderPrompt.move(toParent: overlayNode)
            traderPrompt.position = CGPoint.zero
            
            isPaused = true
            worldNode.isPaused = true
            
        } else {
            print("Error: Failed to load the mission completed prompt")
        }
        
    }
    
   
    
    public func showInventorySummaryForPlayer(atPosition position: CGPoint){
        
        let uniqueItems = player.collectibleManager.getTotalNumberOfUniqueItems()
        let totalItems = player.collectibleManager.getTotalNumberOfAllItems()
        let totalMass = player.collectibleManager.getTotalMassOfAllCollectibles()
        let totalMonetaryValue = player.collectibleManager.getTotalMonetaryValueOfAllCollectibles()
        let carryingCapacity = player.collectibleManager.getTotalCarryingCapacity()
        let totalMetalContent = player.collectibleManager.getTotalMetalContent()
        
        guard let inventorySummaryNode = UIPanelGenerator.GetInventorySummaryNode(withTotalUniqueItems: uniqueItems, withTotalItems: totalItems, withTotalMass: totalMass, withTotalMetalContent: totalMetalContent, withMonetaryValue: totalMonetaryValue, withCarryingCapacity: carryingCapacity) else { return }
        
        inventorySummaryNode.position = position
        inventorySummaryNode.zPosition = 30
        
        inventorySummaryNode.move(toParent: overlayNode)
        
        
    }
    
}
