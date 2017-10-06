//
//  PlayerType.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayerType: String{
    case manBlue
    case manRed
    case manBrown
    case survivor1
    case survivor2
    case hitman1
    case womanOld
    case womanGreen
    case soldier1
    case soldier2
    
    
    enum TextureType: String{
        case stand
        case gun
        case hold
        case reload
        case machine
        case silencer
    }

    
    static let allPlayerTypes: [PlayerType] = [.manRed,.manBrown,.survivor1,.survivor2,.hitman1,.womanOld,.womanGreen,.soldier1,.soldier2,.manBlue]
    
    init(withIntegerValue intValue: Int){
        switch intValue {
        case 1:
            self = .manRed
            break
        case 2:
            self = .manBrown
            break
        case 3:
            self = .survivor1
            break
        case 4:
            self = .survivor2
            break
        case 5:
            self = .hitman1
            break
        case 6:
            self = .womanOld
            break
        case 7:
            self = .womanGreen
            break
        case 8:
            self = .soldier1
            break
        case 9:
            self = .soldier2
            break
        case 10:
            self = .manBlue
            break
        default:
            self = .soldier1
        }
    }
    
    func getIntegerValue() -> Int{
        switch self {
        case .manRed:
            return 1
        case .manBrown:
            return 2
        case .survivor1:
            return 3
        case .survivor2:
            return 4
        case .hitman1:
            return 5
        case .womanOld:
            return 6
        case .womanGreen:
            return 7
        case .soldier1:
            return 8
        case .soldier2:
            return 9
        case .manBlue:
            return 10
  
        }
    }
    
    func getTexture(textureType: TextureType) -> SKTexture{
        
        return SKTexture(imageNamed: self.getTextureName(textureType: textureType))
    
    }
    
    
    func getTextureName(textureType: TextureType) -> String{
        
        var baseString = self.rawValue
        
        baseString.append("_\(textureType.rawValue)")
        
        return baseString

      
    }
    
    
    func getPickerView(withFrame frame: CGRect) -> UIView{
        
        let view = UIView(frame: frame)
        
        let labelFrame = CGRect(x: frame.origin.x + frame.size.width*0.30, y: frame.origin.y, width: frame.size.width*0.70, height: frame.size.height)
        
        let label = UILabel(frame: labelFrame)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width*0.30, height: frame.size.height)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        let texture = getTexture(textureType: .gun)
      
        imageView.image = UIImage(cgImage: texture.cgImage())
        label.text = getPlayerTypeName()
        label.font = UIFont(name: "Didot", size: 20.0)
        
        return view
        
    }
    
    func getPlayerTypeName() -> String{
        switch self {
        case .hitman1:
            return "Black Shirt"
        case .manBlue:
            return "Blue Shirt"
        case .manRed:
            return "Red Shirt"
        case .soldier1:
            return "Soldier"
        case .soldier2:
            return "War Veteran"
        case .survivor1:
            return "Survivor"
        case .survivor2:
            return "Hunter"
        case .womanGreen:
            return "Green Shirt Lady"
        case .womanOld:
            return "Angry Grandma"
        default:
            return "Awesome Player"
        }
    }
}
