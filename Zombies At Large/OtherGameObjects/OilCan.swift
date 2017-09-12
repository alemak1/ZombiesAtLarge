//
//  OilCan.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/12/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class OilCan: SKSpriteNode{
    
    enum OilCanTexture{
        case OilSlick
        case GreenBarrel
        case RedBarrel
        case GreyBarrel
        
        func getTexture() -> SKTexture{
            switch self{
                case .OilSlick:
                    return SKTexture(imageNamed:"oil")
                case .GreenBarrel:
                    return SKTexture(imageNamed:"barrelGreen_up")
                case .GreyBarrel:
                    return SKTexture(imageNamed: "barrelGrey_up")
                case .RedBarrel:
                    return SKTexture(imageNamed: "barrelRed_up")
            }
        }
    }
    
    lazy var explosionAction: SKAction = {
        
        let explosionAnimation = SKAction.animate(with: [
            SKTexture(imageNamed: "regularExplosion00"),
            SKTexture(imageNamed: "regularExplosion01"),
            SKTexture(imageNamed: "regularExplosion02"),
            SKTexture(imageNamed: "regularExplosion03"),
            SKTexture(imageNamed: "regularExplosion04"),
            SKTexture(imageNamed: "regularExplosion05"),
            SKTexture(imageNamed: "regularExplosion06"),
            SKTexture(imageNamed: "regularExplosion07"),
            SKTexture(imageNamed: "regularExplosion08")
            ], timePerFrame: 0.10)
        
        let explosionSound = SKAction.playSoundFileNamed("explosion1", waitForCompletion: false)
        
        return SKAction.group([
            explosionAnimation,
            explosionSound
            ])
        
    }()
    
    convenience init(oilCanTexture: OilCanTexture, andNumberOfZombies numberOfZombies: Int) {
        
        let oilCanTexture = oilCanTexture.getTexture()
        
        self.init(texture: oilCanTexture, color: .clear, size: oilCanTexture.size())
        
        addZombies(numberOfZombies: numberOfZombies)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addZombies(numberOfZombies: Int){
        
        //Use GameplayKit to arrange zombies around bullet
    }
    
    /** Not tested yet **/
    
    func dieAnimation(){
        
        self.run(self.explosionAction, completion: {
            
            self.run(SKAction.run {
                
                for node in self.children{
                    
                    if let zombie = node as? Zombie{
                        
                        zombie.run(self.explosionAction)
                    }
                }
                
            }, completion: {
                
                self.removeFromParent()

            })
        })
        
        
    }
    
}
