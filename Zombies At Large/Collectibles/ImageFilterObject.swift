//
//  ImageFilter.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/11/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class ImageFilterObject: Collectible{
    
    var filterConfiguration: FilterConfiguration!
    
    convenience init(filterConfiguration: FilterConfiguration) {
        self.init(withCollectibleType: .FlaskRed)
        self.filterConfiguration = filterConfiguration
    }
    
    override init(withCollectibleType someCollectibleType: CollectibleType) {
        super.init(withCollectibleType: someCollectibleType)
    }
    
}
