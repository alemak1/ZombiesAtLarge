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
        
        handleCameraPromptTouch(atOverlayNodeTouchLocation: touchLocation)

        handleMissionPanelTouch(atOverlayNodeTouchLocation: touchLocation)
        
        handleGameWinPromptTouch(atOverlayNodeTouchLocation: touchLocation, completion: nil)
        
        handleGameLossPromptTouch(atOverlayNodeTouchLocation: touchLocation, completion: nil)
        
       
        handleMenuOptionsPanelTouch(atOverlayNodeTouchLocation: touchLocation)
        
        handleMenuOptionsButtonTouch(atOverlayNodeTouchLocation: touchLocation)
        
    }
    
    func handleMenuOptionsPanelTouch(atOverlayNodeTouchLocation touchLocation: CGPoint){
        
        if self.menuOptionsPanel != nil{
            
            
            if let touchedOverlayNode = overlayNode.nodes(at: touchLocation).first as? SKSpriteNode{
                
                
                
                if touchedOverlayNode.name == "InventorySummary"{
                    
                    
                    if touchedOverlayNode.name == "InventoryButton"{
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.ShowInventoryCollectionViewNotification), object: nil)
                        
                    } else {
                        
                        touchedOverlayNode.removeFromParent()
                        
                    }
                    
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
                    
                    if(selectedNode.name == "ViewInventory"){
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.ShowInventoryCollectionViewNotification), object: nil)
                        
                        
                    }
                    
                    if(selectedNode.name == "RestartLevel"){
                        
                        menuOptionsPanel!.removeFromParent()
                        menuOptionsPanel = nil
                        
                        let transition = SKTransition.crossFade(withDuration: 2.00)
                        
                        let currentGameScene = GameScene(currentGameLevel: self.currentGameLevel, playerProfile: self.currentPlayerProfile!)
                        
                        view!.presentScene(currentGameScene, transition: transition)
                    }
                    
                    if(selectedNode.name == "CurrentMission"){
                        showMissionPanel()
                    }
                    
                    if(selectedNode.name == "SaveGame"){
                        
                        self.gameSaver.saveGame()
                        
                        print("Game Saved!!")
                    }
                    
                    if(selectedNode.name == "BackToMainMenu"){
                        
                        self.isPaused = true
                        
                        NotificationCenter.default.post(name: Notification.Name.GetDidRequestBackToMainMenuNotification(), object: nil, userInfo: nil)
                        
                        
                    }
                    
                    
                }
                
                
                
            }
            
            
            
            
        }
    }
    
    
    func handleMenuOptionsButtonTouch(atOverlayNodeTouchLocation touchLocation: CGPoint){
        if menuOptionsButton.contains(touchLocation) {
            
            /** The Menu Options Button is deactivated when either of the Menu Options Panel, the GameWinPrompt, GameLossPromt, or CameraMissionPrompt/NPCMissionPrompt are showing**/
            
            if menuOptionsPanel != nil || gameWinPrompt != nil || gameLossPrompt != nil || cameraMissionPrompt != nil || missionPanel != nil{
                return
            }
            
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

    func handleCameraPromptTouch(atOverlayNodeTouchLocation touchLocation: CGPoint){
        
        if cameraMissionPrompt != nil, cameraMissionPrompt!.contains(touchLocation){


            if let node = cameraMissionPrompt?.nodes(at: touchLocation).first as? SKSpriteNode{
                
                
                if node.name == "Camera"{
                    print("Taking a picture with camera...")
                    
                    NotificationCenter.default.post(name: Notification.Name.GetDidRequestCameraOrPhotosNotification(), object: self, userInfo: ["sourceType":"camera"])
                    return
                    
                }
                
                if node.name == "Photos"{
                    print("Pick a photo from albums")
                    
                     NotificationCenter.default.post(name: Notification.Name.GetDidRequestCameraOrPhotosNotification(), object: self, userInfo: ["sourceType":"photos"])
                    return

                    
                }
                
                if node.name == "Cancel"{
                    print("Cancel mission")
                    
                    self.isPaused = false
                    self.worldNode.isPaused = false
                    
                    cameraMissionPrompt!.run(SKAction.run {
                        
                        self.cameraMissionPrompt!.removeFromParent()
                        
                        }, completion: {
                            
                            self.cameraMissionPrompt = nil
                            
                            self.npcPostContactBufferFrameCount = 0
                            
                    })
                   
                    return
                }
                    
                    
                
                
                
               

            }
            
           
           
        }
    }
    
    func handleGameWinPromptTouch(atOverlayNodeTouchLocation touchLocation: CGPoint, completion: (()->Void)?){
        
        print("Handling touch at game win prompt....")

        if gameWinPrompt != nil, gameWinPrompt!.contains(touchLocation){
            
            if let node = gameWinPrompt!.nodes(at: touchLocation).first as? SKSpriteNode{
                
                if node.name == "NextLevel"{
                
                    print("Proceeding to load next level....")
                    let nextLevel = currentGameLevel.getNextLevel()
                
                    let nextGameScene = GameScene(currentGameLevel: nextLevel, playerProfile: self.currentPlayerProfile!)
                
                    self.view!.presentScene(nextGameScene)
                
                    return
                }
            
                if node.name == "MainMenu"{
                
                    print("Proceeding to return to the main menu....")

                    self.isPaused = true
                
                    NotificationCenter.default.post(name: Notification.Name.GetDidRequestBackToMainMenuNotification(), object: nil, userInfo: nil)
                    }
            }
            
        }
        
        if completion != nil{
            completion!()
        }
        
    }
    
    
    func handleGameLossPromptTouch(atOverlayNodeTouchLocation touchLocation: CGPoint, completion: (()->Void)?){
        
        print("Handling touch at game loss prompt....")
        
        if gameLossPrompt != nil, gameLossPrompt!.contains(touchLocation){
            
            if let node = gameLossPrompt?.nodes(at: touchLocation).first as? SKSpriteNode{
            

                    if node.name == "StartAgain"{
                        print("Restarting level....")
                    }
            
            
                    if node.name == "MainMenu"{
                        print("Returning to main menu...")
                
                    }
            }
            
        }
        
        
        if completion != nil{
            completion!()
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
