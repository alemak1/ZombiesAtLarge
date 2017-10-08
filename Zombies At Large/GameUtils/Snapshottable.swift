//
//  Snapshottable.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

protocol Snapshottable{
    
    var snapshot: Saveable{get}
    func getSnapshot() -> Saveable
    
}
