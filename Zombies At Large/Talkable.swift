//
//  Talkable.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

protocol Talkable{
    var avatar: SKTexture {get set}
    
    func makeReply()
}


protocol DialogueCapable{
    
}
