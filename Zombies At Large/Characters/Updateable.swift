//
//  Updateable.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


protocol Updateable{
    
    func updateMovement(forTime currentTime: TimeInterval)
    
}
