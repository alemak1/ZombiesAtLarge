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
    
    static func GetMissionPanelWith(missionTitle: String, missionSubtitle: String, bodyText1: String, bodyText2: String, bodyText3: String, bodyText4: String, bodyText5: String) -> SKNode?{
        
        guard let missionPanel = SKScene(fileNamed: "user_interface")?.childNode(withName: "MissionPrompt") else { return nil }
        
        guard let headerPanel = missionPanel.childNode(withName: "MissionTitle")  else { return nil }
        
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
        
        if let text3_label = headerPanel.childNode(withName: "text3") as? SKLabelNode{
            
            text3_label.text = bodyText3

        }
        
        if let text4_label = headerPanel.childNode(withName: "text4") as? SKLabelNode{
            
            text4_label.text = bodyText4
            
        }
        
        if let text5_label = headerPanel.childNode(withName: "text5") as? SKLabelNode{
            
            text5_label.text = bodyText5
            
        }



        return missionPanel
     
    }
    
    static func GetDialoguePrompt(forAvatar avatar: Avatar, withName name: String,andWithText1 text1: String? = nil,andWithText2 text2: String? = nil, andWithText3 text3: String? = nil, andWithText4 text4: String? = nil) -> SKSpriteNode?{
        
        guard let dialoguePrompt = GetDialoguePrompt(forAvatar: avatar) else { return nil }
        
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
}
