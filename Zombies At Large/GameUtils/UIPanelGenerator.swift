//
//  UIPanelGenerator.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class UIPanelGenerator{
    
    static func GetCameraZombiePrompt() -> SKSpriteNode?{
        
        guard let cameraZombiePrompt = SKScene(fileNamed: "user_interface")?.childNode(withName: "CameraPrompt") else {
            fatalError("Error: failed to load GameOverPrompt")
        }
        
        return cameraZombiePrompt as? SKSpriteNode
        
    }
    
    
    static func GetTraderPrompt() -> SKSpriteNode?{
        
        guard let traderPrompt = SKScene(fileNamed: "user_interface")?.childNode(withName: "MerchantPrompt") else {
            fatalError("Error: failed to load GameOverPrompt")
        }
       
        return traderPrompt as? SKSpriteNode
        
    }
    
    
    static func GetGameWinPrompt(withText1 text1: String, andWithText2 text2: String) -> SKSpriteNode?{
        
        guard let gameWinPrompt = SKScene(fileNamed: "user_interface")?.childNode(withName: "GameWinPrompt") else {
            fatalError("Error: failed to load GameOverPrompt")
        }
        
        if let textLabel1 = gameWinPrompt.childNode(withName: "text1") as? SKLabelNode{
            textLabel1.text = text1
        }
        
        if let textLabel2 = gameWinPrompt.childNode(withName: "text2") as? SKLabelNode{
            textLabel2.text = text2
        }
        
        return gameWinPrompt as? SKSpriteNode
        
    }
    
    
    
    static func GetGameOverPrompt(withText1 text1: String, andWithText2 text2: String) -> SKSpriteNode?{
    
        guard let gameOverPrompt = SKScene(fileNamed: "user_interface")?.childNode(withName: "GameOverPrompt") else {
            fatalError("Error: failed to load GameOverPrompt")
        }
        
        if let textLabel1 = gameOverPrompt.childNode(withName: "text1") as? SKLabelNode{
            textLabel1.text = text1
        }
        
        if let textLabel2 = gameOverPrompt.childNode(withName: "text2") as? SKLabelNode{
            textLabel2.text = text2
        }
        
        return gameOverPrompt as? SKSpriteNode
        
    }
    
    
    static func GetMenuOptionsPanel() -> SKNode{
        
        guard let menuOptionsPanel = SKScene(fileNamed: "user_interface")?.childNode(withName: "OptionsMenu") else {
            
            fatalError("Error: MenuOptions panel could not be found or is unable to load properly ")
        }
        
        return menuOptionsPanel

    }
    
    static func GetMissionPanelFor(gameLevel: GameLevel) -> SKNode?{
        
        print("Getting Mission Panel for Game Level \(gameLevel.rawValue)")
        
        return GetMissionPanelWith(missionTitle: gameLevel.getMissionHeaderText().title, missionSubtitle: gameLevel.getMissionHeaderText().subtitle, bodyText1: gameLevel.getMissionBodyText().0, bodyText2: gameLevel.getMissionBodyText().1, bodyText3: gameLevel.getMissionBodyText().2, bodyText4: gameLevel.getMissionBodyText().3, bodyText5: gameLevel.getMissionBodyText().4)
    }
    
    static func GetMissionPanelWith(missionTitle: String, missionSubtitle: String, bodyText1: String, bodyText2: String, bodyText3: String, bodyText4: String, bodyText5: String) -> SKNode?{
        
        guard let missionPanel = SKScene(fileNamed: "user_interface")?.childNode(withName: "MissionPrompt") else {
            
            print("Error: Unable to find MissionPrompt in user_interface file")
            return nil
            
        }
        
        guard let headerPanel = missionPanel.childNode(withName: "MissionHeader")  else {
            print("Error: Unable to find MissionTitle in user_interface file")
            return nil
            
        }
        
        if let headerTitleLabel = headerPanel.childNode(withName: "MissionTitle") as? SKLabelNode{
            
            headerTitleLabel.text = missionTitle
            
        }
        
        if let headerSubtitleLabel = headerPanel.childNode(withName: "MissionSubtitle") as? SKLabelNode{
            
            headerSubtitleLabel.text = missionSubtitle
        }
        
        guard let bodyPanel = missionPanel.childNode(withName: "MissionBody")  else { return nil }
        
        if let text1_label = bodyPanel.childNode(withName: "text1") as? SKLabelNode{
            
            text1_label.text = bodyText1
            
        }
        
        if let text2_label = bodyPanel.childNode(withName: "text2") as? SKLabelNode{
            
            text2_label.text = bodyText2

        }
        
        if let text3_label = bodyPanel.childNode(withName: "text3") as? SKLabelNode{
            
            text3_label.text = bodyText3

        }
        
        if let text4_label = bodyPanel.childNode(withName: "text4") as? SKLabelNode{
            
            text4_label.text = bodyText4
            
        }
        
        if let text5_label = bodyPanel.childNode(withName: "text5") as? SKLabelNode{
            
            text5_label.text = bodyText5
            
        }



        return missionPanel
     
    }
    
    static func GetDialoguePrompt(forAvatar avatar: Avatar, withName name: String,andWithText1 text1: String? = nil,andWithText2 text2: String? = nil, andWithText3 text3: String? = nil, andWithText4 text4: String? = nil) -> SKSpriteNode?{
        
        guard let dialoguePrompt = GetDialoguePrompt(forAvatar: avatar) else {
            print("ERROR: Failed to load avatar dialogue prompt")
            return nil }
        
        if let nameLabel = dialoguePrompt.childNode(withName: "name") as? SKLabelNode{
            nameLabel.text = name
        }
        
        if let text1 = text1, let text1a_label = dialoguePrompt.childNode(withName: "text1a") as? SKLabelNode{
            
            text1a_label.text = text1
        }
        
        if let text2 = text2, let text1b_label = dialoguePrompt.childNode(withName: "text1b") as? SKLabelNode {
            
            text1b_label.text = text2
        }
        
        if let text3 = text3, let text2a_label = dialoguePrompt.childNode(withName: "text2a") as? SKLabelNode{
            
            text2a_label.text = text3
            
        }
        
        
        if let text4 = text4, let text2b_label = dialoguePrompt.childNode(withName: "text2b") as? SKLabelNode{
            
            text2b_label.text = text4
            
        }
        
        return dialoguePrompt
    }
    
    private static func GetDialoguePrompt(forAvatar avatar: Avatar) -> SKSpriteNode?{
        
        
        switch avatar {
        case .woman:
            return SKScene(fileNamed: "user_interface")?.childNode(withName: "WomanPrompt") as? SKSpriteNode
        case .womanAlternative:
            return SKScene(fileNamed: "user_interface")?.childNode(withName: "WomanAlternativePrompt") as? SKSpriteNode
        case .man:
            return SKScene(fileNamed: "user_interface")?.childNode(withName: "ManPrompt") as? SKSpriteNode
        case .manAlternative:
            return SKScene(fileNamed: "user_interface")?.childNode(withName: "ManAlternativePrompt") as? SKSpriteNode
        case .survivor:
            return SKScene(fileNamed: "user_interface")?.childNode(withName: "SurvivorPrompt") as? SKSpriteNode
        case .robot:
            return SKScene(fileNamed: "user_interface")?.childNode(withName: "RobotPrompt") as? SKSpriteNode
        case .zombie:
             return SKScene(fileNamed: "user_interface")?.childNode(withName: "ZombiePrompt") as? SKSpriteNode
        default:
            return nil
        }
    }
    
    
    static func GetInventorySummaryNode(withTotalUniqueItems uniqueItems: Int, withTotalItems totalItems: Int, withTotalMass totalMass: Double, withTotalMetalContent metalContent: Double, withMonetaryValue monetaryValue: Double, withCarryingCapacity carryingCapacity: Double) -> SKSpriteNode?{
        
        if let inventorySummary = SKScene(fileNamed: "user_interface")?.childNode(withName: "InventorySummary"){
            
            
            
            if let uniqueItemsLabel = inventorySummary.childNode(withName: "totalUniqueItemsLabel") as? SKLabelNode{
                
                uniqueItemsLabel.horizontalAlignmentMode = .center
                uniqueItemsLabel.text = "Number of Unique Items:\(uniqueItems)"
            }
            
            if let totalItemsLabel = inventorySummary.childNode(withName: "totalItemsLabel") as? SKLabelNode{
                
                totalItemsLabel.horizontalAlignmentMode = .center
                totalItemsLabel.text = "Total Number of Items: \(totalItems)"
            }
            
            
            if let metalContentLabel = inventorySummary.childNode(withName: "totalMetalContentLabel") as? SKLabelNode{
                
                metalContentLabel.horizontalAlignmentMode = .center
                metalContentLabel.text = "Total Metal Content: \(metalContent)"
                
            }
            
            if let monetaryValueLabel = inventorySummary.childNode(withName: "totalMonetaryValueLabel") as? SKLabelNode{
                
                monetaryValueLabel.horizontalAlignmentMode = .center
                monetaryValueLabel.text = "Total Monetary Value: \(monetaryValue)"
            }
            
            if let totalMassLabel = inventorySummary.childNode(withName: "totalMassLabel") as? SKLabelNode{
                
                totalMassLabel.horizontalAlignmentMode = .center
                totalMassLabel.text = "Total Mass: \(totalMass)"
                
            }
            
            if let totalCarryingCapacityLabel = inventorySummary.childNode(withName: "totalCarryingCapacityLabel") as? SKLabelNode{
                
                totalCarryingCapacityLabel.horizontalAlignmentMode = .center
                totalCarryingCapacityLabel.text = "Total Carrying Capacity: \(carryingCapacity)"
                
            }
            
            return inventorySummary as? SKSpriteNode
        }
        
        return nil
    }
    
    enum BarColor{
        case Yellow
        case Red
        case Blue
        case Green
        
        
        func getLeftBar() -> SKTexture{
            switch self {
            case .Blue:
                return SKTexture(imageNamed: "barBlue_horizontalLeft")
            case .Red:
                return SKTexture(imageNamed: "barRed_horizontalLeft")
            case .Yellow:
                return SKTexture(imageNamed: "barYellow_horizontalLeft")
            case .Green:
                return SKTexture(imageNamed: "barGreen_horizontalLeft")

            }
        }
        
        
        func getMidBar() -> SKTexture{
            switch self {
            case .Blue:
                return SKTexture(imageNamed: "barBlue_horizontalBlue")
            case .Red:
                return SKTexture(imageNamed: "barRed_horizontalMid")
            case .Yellow:
                return SKTexture(imageNamed: "barYellow_horizontalMid")
            case .Green:
                return SKTexture(imageNamed: "barGreen_horizontalMid")
                
            }
        }
        
    
        func getRightBar() -> SKTexture{
            switch self {
            case .Blue:
                return SKTexture(imageNamed: "barBlue_horizontalRight")
            case .Red:
                return SKTexture(imageNamed: "barRed_horizontalRight")
            case .Yellow:
                return SKTexture(imageNamed: "barYellow_horizontalRight")
            case .Green:
                return SKTexture(imageNamed: "barGreen_horizontalRight")
                
            }
        }
    
    
    }
    
    
    static func getBarIndicator(withColor color: BarColor,forNumberOfUnits units: Int) -> SKNode{
        
        guard let barIndicator = SKScene(fileNamed: "user_interface")?.childNode(withName: "BarIndicator") else {
            
            fatalError("Error: bar indicator failed to load")
        }
        
        let leftBar = color.getLeftBar()
        let midBar = color.getMidBar()
        let rightBar = color.getRightBar()
       
        for barIndex in 0...units{
            
            if(barIndex == 0), let leftBackBar = barIndicator.childNode(withName: "mid0") as? SKSpriteNode{
                
                let leftBarSprite = SKSpriteNode(texture: leftBar)
                leftBarSprite.anchorPoint = CGPoint(x: 1.00, y: 0.5)
                leftBarSprite.move(toParent: barIndicator)
                leftBarSprite.position = leftBackBar.position
                
            }
            
            if(barIndex == 15),let rightBackBar = barIndicator.childNode(withName: "mid15") as? SKSpriteNode{
                
                let rightBarSprite = SKSpriteNode(texture: rightBar)
                rightBarSprite.anchorPoint = CGPoint(x: 0.0, y: 0.5)
                rightBarSprite.move(toParent: barIndicator)
                rightBarSprite.position = rightBackBar.position
                
            }
            
            if let midBackBar = barIndicator.childNode(withName: "mid\(barIndex)") as? SKSpriteNode {
                
                let midBarSprite = SKSpriteNode(texture: midBar)
                midBarSprite.anchorPoint = CGPoint(x: 0.00, y: 0.5)
                midBarSprite.move(toParent: barIndicator)
                midBarSprite.position = midBackBar.position
            }
            
            
            
        }
        
        return barIndicator

    }
    
    static func getBarTexture(barColor: BarColor) -> (SKTexture,SKTexture,SKTexture){
        
        switch barColor {
        case .Blue:
            return (SKTexture(imageNamed: "barBlue_horizontalLeft"),SKTexture(imageNamed: "barBlue_horizontalMid"),SKTexture(imageNamed: "barBlue_horizontalRight"))
        case .Green:
            return (SKTexture(imageNamed: "barGreen_horizontalLeft"),SKTexture(imageNamed: "barGreen_horizontalMid"),SKTexture(imageNamed: "barGreen_horizontalRight"))
        case .Yellow:
            return (SKTexture(imageNamed: "barYellow_horizontalLeft"),SKTexture(imageNamed: "barYellow_horizontalMid"),SKTexture(imageNamed: "barYellow_horizontalRight"))
        case .Red:
            return (SKTexture(imageNamed: "barRed_horizontalLeft"),SKTexture(imageNamed: "barRed_horizontalMid"),SKTexture(imageNamed: "barRed_horizontalRight"))

        }
    }
}
