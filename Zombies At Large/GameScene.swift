//
//  GameScene.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

/**

 The player must collect potions, which in turn remove all of the distortions and filters from a photo, restoring the photo to its original state;  each photo is wrapped in its own sprite node, which in turn is parented by an SKEffectNode; 
 **/


import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: Player!
    var playerProximity: SKSpriteNode!
    
    
    /** Node Layers **/
    
    var overlayNode: SKNode!
    var worldNode: SKNode!
    var mainCameraNode: SKCameraNode!
    
    /** Tile Backgrounds **/
    
    var grassTileMap: SKTileMapNode!
    var blackCorridorTileMap: SKTileMapNode!
    var woodFloorTileMap: SKTileMapNode!
    
    
    /** Control buttons **/
    
    var controlButton: SKSpriteNode!
    
    /**
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var upButton: SKSpriteNode!
    var downButton: SKSpriteNode!
     **/
    
    var fireButton: SKNode!
    
    private var buttonsAreLoaded: Bool = false
    
    
   var bgNode: SKAudioNode!
    
    
    var mainZombie: Zombie!
    var zombieManager: ZombieManager!
 
    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    
    override func didMove(to view: SKView) {
       
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.00, dy: 0.00)
    
        
        
        self.backgroundColor = SKColor.cyan
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.overlayNode = SKNode()
        self.overlayNode.zPosition = 10
        self.overlayNode.position = CGPoint(x: 0.00, y: 0.00)
        addChild(overlayNode)
        
        
        self.worldNode = SKNode()
        worldNode.zPosition = 5
        worldNode.position = CGPoint(x: 0.00, y: 0.00)
        worldNode.name = "world"
        addChild(worldNode)

        let xPosControls = UIScreen.main.bounds.width*0.3
        let yPosControls = -UIScreen.main.bounds.height*0.3
        
        player = Player(playerType: .hitman1, scale: 1.50)
        player.position = CGPoint(x: 0.00, y: 0.00)
        player.zPosition = 6
        worldNode.addChild(player)
        
        self.mainCameraNode = SKCameraNode()
        self.camera = mainCameraNode
        
        zombieManager = ZombieManager(withPlayer: player, andWithLatentZombies: [])
        

        loadFireButton()
        loadControls(atPosition: CGPoint(x: xPosControls, y: yPosControls))
        loadBackground()
    
 
   
        
        
      
    }
    
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        guard let touch = touches.first else { return }
        
        
        let touchLocation = touch.location(in: self)
        let overlayNodeLocation = touch.location(in: overlayNode)

        let fireButtonShape = fireButton as! SKShapeNode
        
        if fireButtonShape.contains(overlayNodeLocation){
    
            player.fireBullet()
            return;
            
        }
        
        
        /** Applied to tank gun turret **/
        
        
       
    
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
            player.applyMovementImpulse(withMagnitudeOf: 5.00)
        
        }
        
        
        
      
       
        
    }
    
    
    
   
   
  
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if(lastUpdateTime == 0){
            lastUpdateTime = currentTime;
        }
    
        frameCount = currentTime - lastUpdateTime;
        
        zombieManager.checkForZombiesInPlayerProximity()
        zombieManager.update(withFrameCount: frameCount)
        
        
        lastUpdateTime = currentTime
        
        
        
        }
    

    override func didSimulatePhysics() {
        player.updatePlayerProximity()
        
        self.mainCameraNode.position = player.position
        overlayNode.position = self.mainCameraNode.position
        
        zombieManager.constrainActiveZombiesToPlayer()

    }
    
    override func didEvaluateActions() {
        
    }
    
    func centerOn(node: SKNode) {
        
        if let parentNode = node.parent,let cameraPositionInScene = node.scene?.convert(node.position, from: parentNode){
            
            parentNode.position = CGPoint(x: parentNode.position.x - cameraPositionInScene.x, y: parentNode.position.y - cameraPositionInScene.y)

        }
        
    }
    
    func loadFireButton(){
        
        fireButton = SKShapeNode(circleOfRadius: 40.00)
        
        let fireButtonShape = fireButton as! SKShapeNode
        fireButtonShape.fillColor = SKColor.red
        fireButtonShape.strokeColor = SKColor.blue
        fireButtonShape.lineWidth = 1.50
        
        fireButtonShape.name = "fireButton"
        
        fireButtonShape.move(toParent: overlayNode)
        
        /** Set the position of the fire button **/
        
        let xPos = -UIScreen.main.bounds.width*0.45
        let yPos = -UIScreen.main.bounds.height*0.34
        
        fireButtonShape.position = CGPoint(x: xPos, y: yPos)
        
        
    }
    
    //TODO: Refactor so that fire button and menu button are added via this function
    
    func loadControls(atPosition position: CGPoint){
        
        /** Load the control set **/

        guard let user_interface = SKScene(fileNamed: "user_interface") else {
            fatalError("Error: User Interface SKSCene file could not be found or failed to load")
        }
        
        
       
        
        buttonsAreLoaded = true
    }
    
    func loadBackground(){
        
        
        guard let grass = SKScene(fileNamed: "backgrounds")?.childNode(withName: "grass") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
        
        let grassRows = grass.numberOfRows
        let grassCols = grass.numberOfColumns
        
        for row in 1...grassRows{
            for col in 1...grassCols{
                
                let tileDef = grass.tileDefinition(atColumn: col, row: row)
                
                let hasZombie = tileDef?.userData?["hasZombie"] as? Bool
                
                if(hasZombie ?? false){
                    let zombiePos = grass.centerOfTile(atColumn: col, row: row)
                    
                    let newZombie = Zombie(zombieType: .zombie1)
                    newZombie.position = zombiePos
                    newZombie.move(toParent: worldNode)
                    zombieManager.addLatentZombie(zombie: newZombie)
                    
                }
                
                
            }
        }
        
        grassTileMap = grass
        
        grassTileMap.position = CGPoint(x: 0.00, y: 0.00)
        
        grassTileMap.move(toParent: self)
 
        
        
        guard let blackCorridors = SKScene(fileNamed: "backgrounds")?.childNode(withName: "blackcorridors") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
        
       
    
        
        for row in 0...blackCorridors.numberOfRows{
            for col in 0...blackCorridors.numberOfColumns{
                
                let tileDef = blackCorridors.tileDefinition(atColumn: col, row: row)
                
                let hasPhysicsBody = tileDef?.userData?["hasPB"] as? Bool
                
                
                if(hasPhysicsBody ?? false){
                        print("Adding another physics body for left edge....")
                
                
                    
                    let tileHeight = blackCorridors.tileSize.height
                    let tileWidth = blackCorridors.tileSize.width
                
                    let tileCenter = blackCorridors.centerOfTile(atColumn: col, row: row)
                    let tileSize = CGSize(width: tileWidth, height: tileHeight)
                    let cgRect = CGRect(origin: tileCenter, size: tileSize)
                    
                    let pbNode = SKNode()
                   let tilePB = SKPhysicsBody(rectangleOf: tileSize, center: tileCenter)
                    
                    tilePB.categoryBitMask = ColliderType.Obstacle.categoryMask
                    tilePB.collisionBitMask = ColliderType.Obstacle.collisionMask
                    tilePB.contactTestBitMask = ColliderType.Obstacle.contactMask
                    
                    tilePB.affectedByGravity = false
                    pbNode.physicsBody = tilePB
                    
                    blackCorridors.addChild(pbNode)
                
                    
                
                }
            }
        }
        
        
        blackCorridorTileMap = blackCorridors

        blackCorridorTileMap.position = CGPoint(x: 0.00, y: 0.00)
        
        
       blackCorridorTileMap.move(toParent: self)
        
        guard let woodFloors = SKScene(fileNamed: "backgrounds")?.childNode(withName: "woodfloor") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
        woodFloors.position = CGPoint(x: 0.00, y: 0.00)
        
        
        
        let woodRows = woodFloors.numberOfRows
        let woodCols = woodFloors.numberOfColumns
        
        for row in 1...woodRows{
            for col in 1...woodCols{
                
                let tileDef = woodFloors.tileDefinition(atColumn: col, row: row)
                
                let hasCollectible = tileDef?.userData?["hasCollectible"] as? Bool
                
                if(hasCollectible ?? false){
                    let collectiblePos = woodFloors.centerOfTile(atColumn: col, row: row)
                    
                    let randomCollectibleType = CollectibleType.getRandomCollectibleType()
                    
                    let randomCollectibleSprite = CollectibleSprite(collectibleType: randomCollectibleType, scale: 0.50)
                    
                    randomCollectibleSprite.position = collectiblePos
                    randomCollectibleSprite.zPosition = 10
                    randomCollectibleSprite.move(toParent: self)
                    
                }
                
                
            }
        }
        
        woodFloorTileMap = woodFloors
        
        woodFloorTileMap.move(toParent: self)
        
    }

}

extension GameScene{
    
    public func showInventorySummaryForPlayer(atPosition position: CGPoint){
        
        let uniqueItems = player.collectibleManager.getTotalNumberOfUniqueItems()
        let totalItems = player.collectibleManager.getTotalNumberOfAllItems()
        let totalMass = player.collectibleManager.getTotalMassOfAllCollectibles()
        let totalMonetaryValue = player.collectibleManager.getTotalMonetaryValueOfAllCollectibles()
        let carryingCapacity = player.collectibleManager.getTotalCarryingCapacity()
        let totalMetalContent = player.collectibleManager.getTotalMetalContent()
        
        guard let inventorySummaryNode = UIPanelGenerator.GetInventorySummaryNode(withTotalUniqueItems: uniqueItems, withTotalItems: totalItems, withTotalMass: totalMass, withTotalMetalContent: totalMetalContent, withMonetaryValue: totalMonetaryValue, withCarryingCapacity: carryingCapacity) else { return }
        
        inventorySummaryNode.position = position
        
        inventorySummaryNode.move(toParent: overlayNode)
        
        
    }
    
}

extension GameScene: SKPhysicsContactDelegate{
    
    func didEnd(_ contact: SKPhysicsContact) {
        print("Contact between bodies has ended")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("Contact was made between two bodies")
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var otherBody: SKPhysicsBody
        
        if((bodyA.categoryBitMask & ColliderType.Player.categoryMask) == 1){
            otherBody = bodyB
        } else {
            otherBody = bodyA
        }
    
        switch otherBody.categoryBitMask {
        case ColliderType.Collectible.categoryMask:
            if let collectibleSprite = otherBody.node as? CollectibleSprite{
                
                let newCollectible = collectibleSprite.getCollectible()
                
                player.addCollectibleItem(newCollectible: newCollectible){
                    
                    self.player.playSoundForCollectibleContact()
                    
       
                    collectibleSprite.removeFromParent()

                }

            }
            /**
                let zombie = otherBody.node as! Zombie
                zombie.activateZombie()
                print("Zombie has been activated")
             **/
            break
        default:
            print("No contact logic implemented")
        }
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

    


    

