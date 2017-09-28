//
//  CollectibleType.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

/** All collectibles have the follow attributes in comon: monetary value, mass (in grams), percent metal content; the player has a limited carrying capacity and cannot add items in excess of that carrying capacity; some items are required to complete specific missions, while others are generally available throughout the game **/

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
    case Camera = 200
    case WallBullet = 201
    case Microscope = 111
    case CompassPointB = 500
    case CompassPointD = 501
    case Bullet1 = 502
    case Bullet2 = 503
    case RiceBowl1 = 504
    case RiceBowl2 = 505
    case RedEnvelope1 = 506
    case RedEnvelope2 = 507
    case Bomb = 510
    case WordScroll = 511
    
    static let allCollectibleTypes:[CollectibleType] = {
        
        print("Generating random collectible items")
        
        var collectibleTypeArray = [CollectibleType]()
        
        for rawValue in 1...115{
            
            if rawValue == 111{
                break
            }
            
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
    
    
    func getDetailInformation() -> String{
        
        switch self {
        case .CD:
            return "This is a CD"
        case .ClosedBook:
            return "This is a closed book"
        default:
            return "No information available for this item"
        }
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
    
    public func getCanBeActivatedStatus() -> Bool{
        
        switch self {
            case .Clipboard:
                return false
            case .Camera:
                return true
            case .WallBullet:
                return true
            case .CD:
                return true
            case .FeatherPen:
                return true
            case .FlaskGreen:
                return true
            case .FlaskRed:
                return false
        default:
            return false
        }
    }
    
    public func getMonetaryUnitValue() -> Double{
        
        switch self{
            case .Clipboard:
                return 3.00
            case .CD:
                return 10.00
            case .Microscope:
                return 200.0
            case .RedEnvelope1:
                return 100.0
            case .RedEnvelope2:
                return 200.0
            default:
                return 0.00
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
        case .Microscope:
            return "Microscope"
        case .CompassPointB,.CompassPointD:
            return "Map Location"
        case .RedEnvelope1,.RedEnvelope2:
            return "RedEnvelope"
        case .RiceBowl1,.RiceBowl2:
            return "RiceBowl"
        case .Bullet1,.Bullet2:
            return "Bullet"
        case .Bomb:
            return "Bomb"
        default:
            return "Some Collecible Item"
        }
    }
    
    public func getUnitMass() -> Double{
        switch self{
        case .PowerDrill:
            return 1633.00
        case .Microscope:
            return 200.00
        case .FeatherPen:
            return 2.5
        case .FountainPenBlue:
            return 5.8
        case .FountainPenRed:
            return 5.8
        case .Clipboard:
            return 10.00
        case .CD:
            return 16.44
        default:
            return 0.00
    
        }
    }
    
    
    public func getPercentMetalContentPerUnit() -> Double{
        
        switch self {
        case .PowerDrill:
            return 0.90
        case .Microscope:
            return 0.70
        case .Clipboard:
            return 0.10
        default:
            return 0.00
        }
    }
    
    
    public func getCollectibleSprite(withScale scale: CGFloat = 1.00) -> CollectibleSprite{
        
        return CollectibleSprite(collectibleType: self, scale: scale)
        
    }
    
    public func getCollectible() -> Collectible{
        
        return Collectible(withCollectibleType: self)
        
    }
    
    func description() -> String{
        
        return "Collectible with name \(self.getCollectibleName()) and a unit monetary value of \(self.getMonetaryUnitValue()) units, and also a unit mass of \(self.getUnitMass()) and percent metal content for unit of \(self.getPercentMetalContentPerUnit())"
    }
    
    
}
