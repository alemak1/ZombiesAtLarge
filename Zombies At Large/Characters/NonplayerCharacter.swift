//
//  NonplayerCharacter.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class NonplayerCharacter: SKSpriteNode{
    
    
    var nonplayerCharacterType: NonplayerCharacterType!

    weak var player: Player! //Check if this is weak or unowned
    
    convenience init?(nonplayerCharacterType: NonplayerCharacterType, andPlayer player: Player) {
        
        guard let texture = nonplayerCharacterType.getTexture() else { return nil }

        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.player = player
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func getPromptNode(promptNode: SKSpriteNode){
        
        if(player.hasItem(ofType: .Camera)){
            
        } else {
            
            
        }
    }
    
    /** Check if the player has a camera or not **/
    
    func getPromptNode(withText: String){
        
        
    }
    
}
