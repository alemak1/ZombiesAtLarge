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
    
    
    /** Current Level **/
    
    var currentGameLevel: GameLevel!
    
    lazy var requiredCollectibles: [CollectibleSprite] = {
        
        var requiredCollectibles = [CollectibleSprite]()

        return requiredCollectibles
        
    }()
    
    var player: Player!
    var playerProximity: SKShapeNode!
    
    
    /** Node Layers **/
    
    var overlayNode: SKNode!
    var worldNode: SKNode!
    var mainCameraNode: SKCameraNode!
    
    /** Mission Panel **/
    
    lazy var missionPanel: SKNode? = {
        
        print("Loading mission panel....")
        
        let missionPanel = UIPanelGenerator.GetMissionPanelFor(gameLevel: self.currentGameLevel)
      
        return missionPanel
        
    }()
    
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
    var menuOptionsButton: SKSpriteNode!
    var menuOptionsPanel: SKNode?
    var backToGameButton: SKSpriteNode?
    
    private var buttonsAreLoaded: Bool = false
    
    
   var bgNode: SKAudioNode!
    
    
    var mainZombie: Zombie!
    var zombieManager: ZombieManager!
 
    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    
    
    /** ***************  GameScene Initializers **/
    convenience init(currentGameLevel: GameLevel) {
        self.init(size: UIScreen.main.bounds.size)
        self.currentGameLevel = currentGameLevel

    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func didMove(to view: SKView) {
       
        initializeBasicNodeLayers()

       // loadMissionPanel()
        
        loadPlayer()
        initializePlayerProximity()
     
        self.mainCameraNode = SKCameraNode()
        self.camera = mainCameraNode
        
        zombieManager = ZombieManager(withPlayer: player, andWithLatentZombies: [])
        
        let xPosControls = UIScreen.main.bounds.width*0.3
        let yPosControls = -UIScreen.main.bounds.height*0.3
        
        loadFireButton()
        loadControls(atPosition: CGPoint(x: xPosControls, y: yPosControls))
        loadBackground()
      
    }
    
    
    func initializeBasicNodeLayers(){
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.00, dy: 0.00)
        
        self.backgroundColor = SKColor.cyan
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.overlayNode = SKNode()
        self.overlayNode.zPosition = 20
        self.overlayNode.position = CGPoint(x: 0.00, y: 0.00)
        addChild(overlayNode)
        
        self.worldNode = SKNode()
        worldNode.zPosition = 5
        worldNode.position = CGPoint(x: 0.00, y: 0.00)
        worldNode.name = "world"
        addChild(worldNode)
    }
    
    func loadMissionPanel(){
    
        
        if let missionPanel = self.missionPanel{
            
            let yPos = UIScreen.main.bounds.size.height*0.10
            
            missionPanel.move(toParent: overlayNode)
            missionPanel.position = CGPoint(x: 0.00, y: yPos)
            missionPanel.zPosition = 20
            
            worldNode.isPaused = true
            isPaused = true
            
        } else {
            print("Error: Mission Panel failed to load")
        }
        
    }
    
    func loadPlayer(){
      
        player = Player(playerType: .hitman1, scale: 1.50)
        player.position = CGPoint(x: 0.00, y: 0.00)
        player.zPosition = 5
        worldNode.addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        
    
        guard let touch = touches.first else { return }
        
        
        let touchLocation = touch.location(in: self)
        let overlayNodeLocation = touch.location(in: overlayNode)

        
    
        if let missionPanel = self.missionPanel, missionPanel.contains(overlayNodeLocation){

            missionPanel.removeFromParent()
            
            isPaused = false
            worldNode.isPaused = false
            
            return;
            
        }
        
        
        
        /**
        
        if self.menuOptionsPanel != nil{
            
            if let touchedOverlayNode = overlayNode.nodes(at: overlayNodeLocation).first as? SKSpriteNode{
                
                if touchedOverlayNode.name == "InventorySummary"{
                    touchedOverlayNode.removeFromParent()
                    
                }
                
            }
            
            if let selectedNode = menuOptionsPanel!.nodes(at: overlayNodeLocation).first as? SKSpriteNode{
                
                print("User touched menu options panel...")
                
            
                if(selectedNode.name == "BackToGame"){
                
                    print("User touched back to game button (test condition uses node name)...")

                    menuOptionsPanel!.removeFromParent()
                    menuOptionsPanel = nil
                    isPaused = false
                    worldNode.isPaused = false
                }
                
                
                if(selectedNode.name == "InventorySummaryOption"){
                    showInventorySummaryForPlayer(atPosition: player.position)
                }
                
                if(selectedNode.name == ""){
                    
                }
               
        
            }
            
            
        }
        
        if menuOptionsButton.contains(overlayNodeLocation) {
            
            if(menuOptionsPanel == nil){
                showMenuOptionsPanel()
            } else {
                
                menuOptionsPanel!.removeFromParent()
                menuOptionsPanel = nil
                isPaused = false
                worldNode.isPaused = false
                
            }
            
            
        
        }
        **/
        
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
    
    
    
   
    func showMenuOptionsPanel(){
 
        isPaused = true
        worldNode.isPaused = true 
        
        let menuOptionsPanel = UIPanelGenerator.GetMenuOptionsPanel()
        
        menuOptionsPanel.position = player.position
        menuOptionsPanel.zPosition = 30
        
        self.menuOptionsPanel = menuOptionsPanel

        self.menuOptionsPanel!.move(toParent: overlayNode)
        
     
        
    }
  
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if(lastUpdateTime == 0){
            lastUpdateTime = currentTime;
        }
    
        frameCount = currentTime - lastUpdateTime;
        
       // zombieManager.checkForZombiesInPlayerProximity()
        zombieManager.update(withFrameCount: frameCount)
        
        
        lastUpdateTime = currentTime
        
        
        
        }
    

    override func didSimulatePhysics() {
        //player.updatePlayerProximity()
        
        self.mainCameraNode.position = player.position
        overlayNode.position = self.mainCameraNode.position
        
        zombieManager.constrainActiveZombiesToPlayer()

    }
    
    override func didEvaluateActions() {
        updatePlayerProximity()
        //player.updatePlayerProximity()
       // player.getPlayerProximityNode().position = player.position
    }
    
    
    func initializePlayerProximity(){
        
        playerProximity = SKShapeNode(circleOfRadius: 10.0)
        worldNode.addChild(playerProximity)
        
        playerProximity.position = self.position
        playerProximity.name = "playerProximity"
        
        
        let playerProximityPB = SKPhysicsBody(circleOfRadius: 200.0)
        playerProximityPB.affectedByGravity = false
        playerProximityPB.linearDamping = 0.00
        playerProximityPB.isDynamic = false
        playerProximityPB.allowsRotation = false
        playerProximityPB.categoryBitMask = ColliderType.PlayerProximity.categoryMask
        playerProximityPB.collisionBitMask = ColliderType.PlayerProximity.collisionMask
        playerProximityPB.contactTestBitMask = ColliderType.PlayerProximity.contactMask
        playerProximity.physicsBody = playerProximityPB
        
        /**
        let joint = SKPhysicsJointFixed()
        joint.bodyA = player.physicsBody!
        joint.bodyB = playerProximity.physicsBody!
        **/

    }
    
    func updatePlayerProximity(){
        playerProximity.position = player.position
    }
    
    func centerOn(node: SKNode) {
        
        if let parentNode = node.parent,let cameraPositionInScene = node.scene?.convert(node.position, from: parentNode){
            
            parentNode.position = CGPoint(x: parentNode.position.x - cameraPositionInScene.x, y: parentNode.position.y - cameraPositionInScene.y)

        }
        
    }
    
    func loadFireButton(){
        
        fireButton = SKShapeNode(circleOfRadius: 40.00)
        
        let fireButtonShape = fireButton as! SKShapeNode
        fireButtonShape.fillColor = SKColor.cyan
        fireButtonShape.strokeColor = SKColor.black
        fireButtonShape.fillTexture = SKTexture(image: #imageLiteral(resourceName: "gun50"))
        
        fireButtonShape.lineWidth = 1.50
        
        fireButtonShape.name = "fireButton"
        
        fireButtonShape.move(toParent: overlayNode)
        
        /** Set the position of the fire button **/
        
        let xPos = -UIScreen.main.bounds.width*0.35
        let yPos = -UIScreen.main.bounds.height*0.4
        
        fireButtonShape.position = CGPoint(x: xPos, y: yPos)
        
        
    }
    
    //TODO: Refactor so that fire button and menu button are added via this function
    
    func loadControls(atPosition position: CGPoint){
        
        /** Load the control set **/

        guard let user_interface = SKScene(fileNamed: "user_interface") else {
            fatalError("Error: User Interface SKSCene file could not be found or failed to load")
        }
        
        guard let menuOptionsButton = user_interface.childNode(withName: "OptionsMenuButton") as? SKSpriteNode else {
            fatalError("Error: Options Menu button could not be loaded from user_interface.sks file")
        }
        
        let xPos = UIScreen.main.bounds.size.width*0.4
        let yPos = UIScreen.main.bounds.size.height*0.4
        
        self.menuOptionsButton = menuOptionsButton
        self.menuOptionsButton.position = CGPoint(x: xPos, y: yPos)
        self.menuOptionsButton.move(toParent: overlayNode)
       
        
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
        
        var randomTileCoord = [(randomRow: Int,randomCol: Int)]()
        
        
            for _ in 0..<5{
                let randomRow = Int(arc4random_uniform(UInt32(woodRows)))
                let randomCol = Int(arc4random_uniform(UInt32(woodCols)))
                
                randomTileCoord.append((randomRow: randomRow,randomCol: randomCol))
                
            }
        
        
      
        
        
        
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
                    
                    for randomCoord in randomTileCoord{
                        if randomCoord.randomRow == row && randomCoord.randomCol == col{
                            
                            let microscope = CollectibleSprite(collectibleType: .Microscope)
                            
                            microscope.position = collectiblePos
                            microscope.zPosition = 10
                            microscope.move(toParent: self)
                            
                            requiredCollectibles.append(microscope)
                            
                            
                        }
                    }
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
        inventorySummaryNode.zPosition = 30
        
        inventorySummaryNode.move(toParent: overlayNode)
        
        
    }
    
}

extension GameScene: SKPhysicsContactDelegate{
    
    func didEnd(_ contact: SKPhysicsContact) {
        print("Contact between bodies has ended")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        handlePlayerContacts(contact: contact)
        handlePlayerProximityContacts(contact: contact)
        handlePlayerBulletContacts(contact: contact)
    
    
    }
    
    
    func handleZombieContacts(contact: SKPhysicsContact){
        
        print("Handling the zombie contacts")
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var nonZombieBody: SKPhysicsBody
        var zombieBody: SKPhysicsBody
        
        if(bodyA.categoryBitMask & ColliderType.Enemy.categoryMask == 1){
            nonZombieBody = bodyB
            zombieBody = bodyA
        } else {
            nonZombieBody = bodyA
            zombieBody = bodyB
        }

        
        switch nonZombieBody.categoryBitMask {
        case ColliderType.PlayerBullets.categoryMask:
            print("The zombie has contacted the player bullet")
            break
        case ColliderType.PlayerProximity.categoryMask:
            print("The zombie has contacted the player proximitiy zone")
            break
        default:
            print("No logic implemented for collision btwn zombie and entity of this type")
        }
    }
    
    /** Helper function to implement contact logic between player bullets and entites that have contacted the player bullets **/
    
    func handlePlayerBulletContacts(contact: SKPhysicsContact){
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var playerBulletPB: SKPhysicsBody
        var nonPlayerBulletPB: SKPhysicsBody
        
        if(bodyA.categoryBitMask & ColliderType.PlayerBullets.categoryMask == 1){
            nonPlayerBulletPB = bodyB
            playerBulletPB = bodyA
        } else {
            nonPlayerBulletPB = bodyA
            playerBulletPB = bodyB
        }
        
        switch nonPlayerBulletPB.categoryBitMask {
        case ColliderType.Enemy.categoryMask:
            print("The bullet has hit a zombie")
            if let zombie = nonPlayerBulletPB.node as? Zombie, let playerBullet = playerBulletPB.node as? SKSpriteNode{
                
                zombie.takeHit()
                self.run(SKAction.wait(forDuration: 0.05), completion: {
                    playerBullet.removeFromParent()
                })
                
            }
            break
        default:
            print("No contact logic implemented")
        }
        
    }
    
    
    /** Helper function to implement the contact logic between the player proximity and the entities in contact with the player proximity zone **/
    
    func handlePlayerProximityContacts(contact: SKPhysicsContact){
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        var nonplayerProximityPB: SKPhysicsBody
        
        
        if(bodyA.categoryBitMask & ColliderType.PlayerProximity.categoryMask == 1){
            nonplayerProximityPB = bodyB
        } else {
            nonplayerProximityPB = bodyA
        }
        
        switch nonplayerProximityPB.categoryBitMask {
        case ColliderType.Enemy.categoryMask:
            print("The player proximity contacted the zombie")
            if let zombie = nonplayerProximityPB.node as? Zombie{
                zombieManager.activateZombie(zombie: zombie)
            }
            break
        default:
            break
        }

    }
    
    
    /** Helper function to implement contact logic between player and the other entity that has contacted a player **/
    
func handlePlayerContacts(contact: SKPhysicsContact){
    
        print("Processing player contact with other body...")
    
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        
        var nonPlayerBody: SKPhysicsBody
        
        if((bodyA.categoryBitMask & ColliderType.Player.categoryMask) == 1){
            nonPlayerBody = bodyB
        } else {
            nonPlayerBody = bodyA
        }
        
        
        switch nonPlayerBody.categoryBitMask {
        case ColliderType.Collectible.categoryMask:
            print("The player has contacted a collectible")
            if let collectibleSprite = nonPlayerBody.node as? CollectibleSprite{
                
                let newCollectible = collectibleSprite.getCollectible()
                
                player.addCollectibleItem(newCollectible: newCollectible){
                    
                    self.player.playSoundForCollectibleContact()
                    
                    
                    collectibleSprite.removeFromParent()
                    
                }
                
            }
            break
 
        default:
            print("Failed to process player contact with entity: No contact logic implemented for contact between player and this entity")
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

    


    

