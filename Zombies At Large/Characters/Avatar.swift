//
//  Avatar.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


enum Avatar: String{
    
    case woman
    case womanAlternative
    case man
    case manAlternative
    case zombie
    case robot
    case soldier
    case survivor
    
    func getAvatarTexture() -> SKTexture{
        
        let baseStr = "face_"
        
        let avatarName = baseStr.appending(self.rawValue)
        
        return SKTexture(imageNamed: avatarName)
    }
    
}
