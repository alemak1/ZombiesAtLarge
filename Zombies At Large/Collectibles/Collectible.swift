//
//  Collectible.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class Collectible: Equatable, Hashable{
    
    private var collectibleType: CollectibleType!
    private var totalQuantity: Int = 1
    
    
    init(withCollectibleType someCollectibleType: CollectibleType){
        
        self.collectibleType = someCollectibleType
        
    }
    

    public func getCollectibleMetalContent() -> Double{
        return collectibleType.getPercentMetalContentPerUnit()*getCollectibleMass()
    }
    
    public func getCollectibleMonetaryValue() -> Double{
        return self.collectibleType.getMonetaryUnitValue()*Double(self.totalQuantity)
    }
    
    public func getCollectibleMass() -> Double{
        return self.collectibleType.getUnitMass()*Double(self.totalQuantity)
    }
    
    public func getQuantityOfCollectible() -> Int{
        return self.totalQuantity
    }
    
    public func changeQuantityTo(newQuantity: Int){
        self.totalQuantity = newQuantity
    }
    
    
    static func == (lhs: Collectible, rhs: Collectible) -> Bool{
        
        return lhs.collectibleType.rawValue == rhs.collectibleType.rawValue
        
    }
    /** Each collectible item is unique;  override hashValue so that the collectible can be inserted into a set such that only one collectible of a given collectible type can be present in the collectible manager at a given time **/
    
    var hashValue: Int{
        
        return self.collectibleType.rawValue
    }
    
    
}
