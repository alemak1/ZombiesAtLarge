//
//  ImageManager.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

/** Stores the images the player character's obtain via the camera or album and is accessed by NPCs that need to perform Vision analysis when the player comes into contact **/


import Foundation
import SpriteKit


class ImageManager{
    
    static let sharedImageManager = ImageManager()
    
    var firstImage: UIImage?
    var secondImage: UIImage?
    var thirdImage: UIImage?
    
    
    private init() {

    }
    
    
    
}

