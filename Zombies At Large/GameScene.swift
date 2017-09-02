//
//  GameScene.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: Player!
    
    /** **/
    
    var overlayNode: SKNode!
    
    /** Control buttons **/
    
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var upButton: SKSpriteNode!
    var downButton: SKSpriteNode!
    
    
    private var buttonsAreLoaded: Bool = false
    
    
   var bgNode: SKAudioNode!
    
    override func didMove(to view: SKView) {
       
        self.backgroundColor = SKColor.cyan
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.overlayNode = SKNode()
        self.overlayNode.position = CGPoint(x: 0.00, y: 0.00)
        addChild(overlayNode)
        
        player = Player(playerType: .hitman1, scale: 1.50)
        player.position = CGPoint(x: 0.00, y: 0.00)
        self.addChild(player)
        
        let xPosControls = UIScreen.main.bounds.width*0.2
        let yPosControls = -UIScreen.main.bounds.height*0.3
        
        loadControls(atPosition: CGPoint(x: xPosControls, y: yPosControls))
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
   
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        guard let touch = touches.first else { return }
        
        let overlayNodeLocation = touch.location(in: overlayNode)
        
        if buttonsAreLoaded{

            for node in self.overlayNode.nodes(at: overlayNodeLocation){
          
                    if node.name == "up"{
                        player.currentOrientation = .up
                        player.applyMovementImpulse(withMagnitudeOf: 1.5)

                    }
                    
                    if node.name == "down"{
                        player.currentOrientation = .down
                        player.applyMovementImpulse(withMagnitudeOf: 1.5)

                    }
                    
                    if node.name == "right"{
                        player.currentOrientation = .right
                        player.applyMovementImpulse(withMagnitudeOf: 1.5)

                    }
                    
                    if node.name == "left"{
                        player.currentOrientation = .left
                        player.applyMovementImpulse(withMagnitudeOf: 1.5)

                    }
 
                }
            }
            
      }
        
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
   private func loadControls(atPosition position: CGPoint){
        
        /** Load the control set **/

        guard let user_interface = SKScene(fileNamed: "user_interface") else {
            fatalError("Error: User Interface SKSCene file could not be found or failed to load")
        }
        
        guard let controlSet = user_interface.childNode(withName: "ControlSet_flatDark") else {
            fatalError("Error: Control Buttons from user_interface SKScene file either could not be found or failed to load")
        }
 
        controlSet.position = position
        controlSet.move(toParent: overlayNode)
 
        /** Load the control buttons **/
 
        guard let leftButton = controlSet.childNode(withName: "left") as? SKSpriteNode, let rightButton = controlSet.childNode(withName: "right") as? SKSpriteNode, let upButton = controlSet.childNode(withName: "up") as? SKSpriteNode, let downButton = controlSet.childNode(withName: "down") as? SKSpriteNode else {
            fatalError("Error: One of the control buttons either could not be found or failed to load")
        }
 
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.upButton = upButton
        self.downButton = downButton
 
        buttonsAreLoaded = true
        print("buttons successfully loaded!")

    }

}

    

