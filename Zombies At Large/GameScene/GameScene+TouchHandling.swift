//
//  GameScene+TouchHandling.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/15/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene{
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        let overlayNodeLocation = touch.location(in: overlayNode)
        
        
      
        
        handleOverlayNodeTouch(touchLocation: overlayNodeLocation)
        
        /** Applied to tank gun turret **/
        
        let fireButtonShape = fireButton as! SKShapeNode

        if fireButtonShape.contains(overlayNodeLocation){
            
            player.fireBullet()
            return;
            
        }

        handlePlayerMovement(touchLocation: touchLocation)
 
        
    }
    
    
    func handleGunFireControl(atOverlayTouchLocation touchLocation: CGPoint){
        let fireButtonShape = fireButton as! SKShapeNode
        
        if fireButtonShape.contains(touchLocation){
            
            player.fireBullet()
            return;
            
        }
    }
    
    func handlePlayerMovement(touchLocation: CGPoint){
        
        
        let xDelta = (touchLocation.x - player.position.x)
        let yDelta = (touchLocation.y - player.position.y)
        
        let absDeltaX = abs(xDelta)
        let absDeltaY = abs(yDelta)
        
        var zRotation: CGFloat = 0.00
        
        if(xDelta > 0){
            
            if(yDelta > 0){
                zRotation = atan(absDeltaY/absDeltaX)
            } else {
                zRotation = 2*CGFloat.pi - atan(absDeltaY/absDeltaX)
            }
            
        } else {
            
            if(yDelta > 0){
                
                zRotation = CGFloat.pi - atan(absDeltaY/absDeltaX)
                
            } else {
                zRotation = CGFloat.pi + atan(absDeltaY/absDeltaX)
                
            }
        }
        
        if(zRotation <= CGFloat.pi*2){
            
            player.compassDirection = CompassDirection(zRotation: zRotation)
            player.applyMovementImpulse(withMagnitudeOf: 5.00)
            
        }
        
    }
    
    func handleOverlayNodeTouch(touchLocation: CGPoint){
        
        if let touchedOverlayNode = overlayNode.nodes(at: touchLocation).first as? SKSpriteNode{
            
            handleMissionPanelTouch(atOverlayNodeTouchLocation: touchLocation)
            
            
            
            if self.menuOptionsPanel != nil{
                
                
                if touchedOverlayNode.name == "InventorySummary"{
                    touchedOverlayNode.removeFromParent()
                    
                }
                
                
                
                if let selectedNode = menuOptionsPanel!.nodes(at: touchLocation).first as? SKSpriteNode{
                    
                    print("User touched menu options panel...")
                    
                    
                    if(selectedNode.name == "BackToGame"){
                        
                        print("User touched back to game button (test condition uses node name)...")
                        
                        menuOptionsPanel!.removeFromParent()
                        menuOptionsPanel = nil
                        isPaused = false
                        worldNode.isPaused = false
                    }
                    
                    
                    if(selectedNode.name == "InventorySummaryOption"){
                        showInventorySummaryForPlayer(atPosition: player.position)
                    }
                    
                    if(selectedNode.name == "RestartLevel"){
                        
                        menuOptionsPanel!.removeFromParent()
                        menuOptionsPanel = nil

                        let transition = SKTransition.crossFade(withDuration: 2.00)
                        let currentGameScene = GameScene(currentGameLevel: self.currentGameLevel)
                        view!.presentScene(currentGameScene, transition: transition)
                    }
                    
                    if(selectedNode.name == "CurrentMission"){
                        showMissionPanel()
                    }
                    
                    
                }
                
                return;
                
            }
            
            if menuOptionsButton.contains(touchLocation) {
                
                if(menuOptionsPanel == nil){
                    showMenuOptionsPanel()
                } else {
                    
                    menuOptionsPanel!.removeFromParent()
                    menuOptionsPanel = nil
                    isPaused = false
                    worldNode.isPaused = false
                    
                }
                
                
                
            }
            
           
            
        }
        
        
    }
    

    func handleMissionPanelTouch(atOverlayNodeTouchLocation touchLocation: CGPoint){
        
        if let missionPanel = self.missionPanel, missionPanel.contains(touchLocation){
            
            missionPanel.removeFromParent()
            self.missionPanel = nil
            
            if menuOptionsPanel == nil{
                isPaused = false
                worldNode.isPaused = false
                
            } 
            
            return;
            
        }
        
    }
    
    
    func showMenuOptionsPanel(){
        
        isPaused = true
        worldNode.isPaused = true
        
        let menuOptionsPanel = UIPanelGenerator.GetMenuOptionsPanel()
        
        menuOptionsPanel.position = player.position
        menuOptionsPanel.zPosition = 30
        
        self.menuOptionsPanel = menuOptionsPanel
        
        self.menuOptionsPanel!.move(toParent: overlayNode)
        
        
        
    }
    
    func showMissionPanel(){
        
        
        self.missionPanel = UIPanelGenerator.GetMissionPanelFor(gameLevel: self.currentGameLevel)
        
        if let missionPanel = self.missionPanel{
            let yPos = UIScreen.main.bounds.size.height*0.10
            
            missionPanel.move(toParent: overlayNode)
            missionPanel.position = CGPoint(x: 0.00, y: yPos)
            missionPanel.zPosition = 30
            
            worldNode.isPaused = true
            isPaused = true
            
        } else {
            print("Error: Mission Panel failed to load")
        }
    }

}
