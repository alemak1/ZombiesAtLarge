//
//  ColliderType.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/6/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

enum ColliderType: UInt32{
    case Player = 0b0
    case Wall = 0b1
    case Zombie = 0b10
    case PlayerProximity = 0b1000
}

