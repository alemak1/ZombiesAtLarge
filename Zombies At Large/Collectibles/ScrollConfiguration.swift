//
//  ScrollConfiguration.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/28/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

struct ScrollConfiguration: Hashable,Equatable{
    
    var text: String
    var title: String
    
    static func == (lhs: ScrollConfiguration, rhs: ScrollConfiguration) -> Bool{
        
        return lhs.hashValue == rhs.hashValue
        
    }
    /** Each collectible item is unique;  override hashValue so that the collectible can be inserted into a set such that only one collectible of a given collectible type can be present in the collectible manager at a given time **/
    
    var hashValue: Int{
        
        return "\(title),\(text)".hashValue
    }
    
}
