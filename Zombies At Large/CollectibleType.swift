//
//  CollectibleType.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

enum CollectibleType: Int{
    case PowerDrill = 1
    case PaintBrush = 11
    case Saw = 16
    case Pencil = 24
    case Pen = 25
    case FountainPenRed = 27
    case FountainPenBlue = 28
    case FeatherPen = 29
    case ClosedBook = 35
    case Clipboard = 38
    case CD = 88
    case Toothbrush = 95
    case MedKit = 102
    case FlaskRed = 107
    case FlaskGreen = 108
    case Microscope = 111
    
    
    static let allCollectibleTypes:[CollectibleType] = {
        
        print("Generating random collectible items")
        
        var collectibleTypeArray = [CollectibleType]()
        
        for rawValue in 1...111{
            
            if let anotherCollectibleType = CollectibleType(rawValue: rawValue){
                
                collectibleTypeArray.append(anotherCollectibleType)
                
            }
        }
        
        return collectibleTypeArray
        
    }()
    
    static func getRandomCollectibleType() -> CollectibleType{
        
        print("Getting a random collectible item....")
        
        let randomIdx = arc4random_uniform(UInt32(allCollectibleTypes.count))
        
        print("Random collectible with index \(randomIdx) obtained")
        
        return allCollectibleTypes[Int(randomIdx)]
    }
    
    
    func getTexture() -> SKTexture{
        
        let baseStr = "genericItem_color_"
        
        var finalStr: String = String()
        
        if(self.rawValue > 100){
            
            finalStr = baseStr.appending("\(self.rawValue)")

        } else if(self.rawValue > 10){
            
            finalStr = baseStr.appending("0\(self.rawValue)")
            
        } else {
            
            finalStr = baseStr.appending("00\(self.rawValue)")

        }
        
        
        return SKTexture(imageNamed: finalStr)
    }
    
    public func getMonetaryValue() -> Double{
        
        switch self{
            case .Clipboard:
                return 3.00
            case .CD:
                return 10.00
            case .Microscope:
                return 200.0
            default:
                return 10.00
        }
    }
    
    public func getCollectibleName() -> String{
        switch self{
        case .PowerDrill:
            return "PowerDrill"
        case .PaintBrush:
            return "Paintbrush"
        case .Saw:
            return "Saw"
        case .ClosedBook:
            return "ClosedBook"
        case .FeatherPen:
            return "FeatherPen"
        case .FlaskRed:
            return "Red Flask"
        case .FlaskGreen:
            return "Green Flask"
        case .FountainPenBlue:
            return "Blue Fountain Pen"
        case .FountainPenRed:
            return "Red Fountain Pen"
        case .Clipboard:
            return "Clipboard"
        default:
            return "Some Collecible Item"
        }
    }
    
    
    public func getCollectible(withScale scale: CGFloat = 1.00) -> Collectible{
        
        return Collectible(collectibleType: self, scale: scale)
    }
    
    func description() -> String{
        
        return "Collectible with name \(self.getCollectibleName()) and monetary value of \(self.getMonetaryValue()) units"
    }
    
    
}
