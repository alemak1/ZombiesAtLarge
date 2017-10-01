//
//  WordGameScene.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class WordGameScene: BaseScene{
    
    /** Reference to ResourceLoader singleton **/
    
    let resourceLoader = ResourceLoader.sharedLoader
    
    var originalWorldNode: SKNode!
    var originalOverlayNode: SKNode!
    var originalBackgroundNode: SKNode!

    
    convenience init(preloadedBackgroundNode: SKNode, preloadedWorldNode: SKNode, preloadedOverlayNode: SKNode) {
        
        let screenSize = UIScreen.main.bounds.size
        self.init(size: screenSize)
        
        /** Copies to the original nodes are maintained in order to restart the game; another approach is to maintain a reference to the original scene in the GameViewController, so that a notification can be sent to the WordGameLevelController to quickly restart the current game **/
        
        /** WARNING: MAY BE NECESARY TO SUBCLASS COPY OR CREATE AN EXTENSION TO SKNODE SO AS TO GET A DEEP COPY AS OPPOSED TO A SHALLOW COPY **/
        self.originalWorldNode = preloadedWorldNode.copy() as! SKNode
        self.originalOverlayNode = preloadedOverlayNode.copy() as! SKNode
        self.originalBackgroundNode = preloadedBackgroundNode.copy() as! SKNode
        
        self.worldNode = preloadedWorldNode
        self.backgroundNode = preloadedBackgroundNode
        self.overlayNode = preloadedOverlayNode
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
       
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
    }
    
    override func didEvaluateActions() {
        super.didEvaluateActions()
        
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
    }
    
  
}


extension WordGameScene{
    
    
    override func didBegin(_ contact: SKPhysicsContact) {
        super.didBegin(contact)
    }
    
    override func didEnd(_ contact: SKPhysicsContact) {
        super.didEnd(contact)
    }
    
}
