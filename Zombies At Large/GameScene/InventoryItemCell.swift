//
//  InventoryItemCell.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/23/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class InventoryItemCell: UICollectionViewCell{
    
    @IBOutlet weak var itemImage: UIImageView!
    
    
    @IBOutlet weak var itemName: UILabel!
    
    
    
        var itemUnitValue: Double = 0.00
    var numberOfItems: Int = 0
    var totalValue: Double = 0.00
    var itemUnitMetalContent: Double = 0.00
    var totalMetalContent: Double = 0.00
    
   
    
}
