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
    
    var controlButton: SKSpriteNode!
    
    /**
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var upButton: SKSpriteNode!
    var downButton: SKSpriteNode!
     **/
    
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
        
        let xPosControls = UIScreen.main.bounds.width*0.3
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
        
        print("You touched the screen")
        
        
        let touchLocation = touch.location(in: self)
        
        print("Screen touched at position x: \(touchLocation.x), y: \(touchLocation.y)")
    
        let xDelta = (touchLocation.x - player.position.x)
        let yDelta = (touchLocation.y - player.position.y)
        
        let absDeltaX = abs(xDelta)
        let absDeltaY = abs(yDelta)
        
        var zRotation: CGFloat = 0.00
        
        if(xDelta > 0){
            
            if(yDelta > 0){
                zRotation = atan(absDeltaY/absDeltaX)
            } else {
                zRotation = 2*CGFloat.pi - atan(absDeltaY/absDeltaX)
            }
            
        } else {
            
            if(yDelta > 0){
                
                zRotation = CGFloat.pi - atan(absDeltaY/absDeltaX)

            } else {
                zRotation = CGFloat.pi + atan(absDeltaY/absDeltaX)

            }
        }
        
        if(zRotation <= CGFloat.pi*2){
            
            player.compassDirection = CompassDirection(zRotation: zRotation)
        
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
    
    
    func loadControls(atPosition position: CGPoint){
        
        /** Load the control set **/

        guard let user_interface = SKScene(fileNamed: "user_interface") else {
            fatalError("Error: User Interface SKSCene file could not be found or failed to load")
        }
        
        
        guard let controlButton = user_interface.childNode(withName: "RoundControl_flatDark")?.childNode(withName: "ControlButton") as? SKSpriteNode else {
            fatalError("Error: Control Buttons from user_interface SKScene file either could not be found or failed to load")
        }
        

        self.controlButton = controlButton
        
        controlButton.position = position
        controlButton.move(toParent: overlayNode)
        
        buttonsAreLoaded = true
    }

}
        /**
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
 
         **/

    

/**
    func addSwipeGestureRecognizers(){
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = .right
        self.view?.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = .left
        self.view?.addGestureRecognizer(swipeLeft)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = .down
        self.view?.addGestureRecognizer(swipeDown)
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = .up
        self.view?.addGestureRecognizer(swipeUp)

        
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            
            switch swipeGesture.direction{

            case UISwipeGestureRecognizerDirection.right:
    
                break
            case UISwipeGestureRecognizerDirection.left:
                break
            case UISwipeGestureRecognizerDirection.down:
                break
            case UISwipeGestureRecognizerDirection.up:
                break
            default:
                break;
            }
            
        }
 
     **/
        

    

