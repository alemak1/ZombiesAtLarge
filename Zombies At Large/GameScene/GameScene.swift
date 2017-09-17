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
    
    var zombiesKilled: Int = 0
    
    
    /** Node Layers **/
    
    var overlayNode: SKNode!
    var worldNode: SKNode!
    var mainCameraNode: SKCameraNode!
    
    var hudNode: SKNode{
        return HUDManager.sharedManager.getHUD()
    }
    
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
    
    var fireButton: SKNode!
    var menuOptionsButton: SKSpriteNode!
    var menuOptionsPanel: SKNode?
    var backToGameButton: SKSpriteNode?
    
    private var buttonsAreLoaded: Bool = false
    
    
   var bgNode: SKAudioNode!
    var zombieManager: ZombieManager!

    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    
    var dialoguePanelIsShown: Bool = false
    
    /** ***************  GameScene Initializers **/
    convenience init(currentGameLevel: GameLevel) {
        self.init(size: UIScreen.main.bounds.size)
        self.currentGameLevel = currentGameLevel
        
        NotificationCenter.default.addObserver(self, selector: #selector(incrementZombieKillCount), name: Notification.Name(rawValue: "didKillZombieNotification"), object: nil)

    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    
    override func didMove(to view: SKView) {
       
        initializeBasicNodeLayers()

        loadMissionPanel()
        
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
        loadHUD()
        
        let bomb = Bomb(scale: 1.00)
        bomb.move(toParent: worldNode)
        bomb.position = CGPoint(x: 150.0, y: 10.0)
        
       
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
    
  
    func loadHUD(){
        hudNode.move(toParent: overlayNode)
        hudNode.zPosition = 35
        
        let xPos = -UIScreen.main.bounds.size.width*0.1
        let yPos = UIScreen.main.bounds.size.height*0.36
        hudNode.position = CGPoint(x: xPos, y: yPos)
        
    }
    
   
  
    @objc func incrementZombieKillCount(){
        self.zombiesKilled += 1
        print("Total number of zombies currently killed is: \(self.zombiesKilled)")
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if(lastUpdateTime == 0){
            lastUpdateTime = currentTime;
        }
    
        frameCount = currentTime - lastUpdateTime;
        
        
        if(self.zombiesKilled > 5 && !dialoguePanelIsShown){
            print("You killed over 5 zombies")
            
            if let dialoguePanel = UIPanelGenerator.GetDialoguePrompt(forAvatar: .zombie, withName: "Zombie King", andWithText1: "How dare you?", andWithText2: "You will", andWithText3: "never save", andWithText4: "the pandas!"){
            
                dialoguePanel.move(toParent: overlayNode)
                dialoguePanel.position = CGPoint.zero
            
                run(SKAction.wait(forDuration: 5.00), completion: {
                
                    dialoguePanel.removeFromParent()
                })
            } else {
                print("ERROR: Dialogue panel failed to load")
            }
            
            dialoguePanelIsShown = true
        }
        
        zombieManager.update(withFrameCount: currentTime)

        
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
                let hasRedEnvelope = tileDef?.userData?["hasRedEnvelope"] as? Bool
                let hasBullet = tileDef?.userData?["hasBullet"] as? Bool
                let hasRiceBowl = tileDef?.userData?["hasRiceBowl"] as? Bool
                
                
                if(hasRedEnvelope ?? false){
                    print("Adding a red envelope to the scene")

                    let redEnvelopePos = grass.centerOfTile(atColumn: col, row: row)
                    
                    let redEnvelope = RedEnvelope(monetaryValue: nil)
                    redEnvelope.move(toParent: worldNode)
                    redEnvelope.position = redEnvelopePos


                }
                
                if(hasBullet ?? false){
                    print("Adding a bullet to the scene")
                    
                    let bulletPos = grass.centerOfTile(atColumn: col, row: row)
                    
                    let bullet = Bullet(numberOfBullets: 1)
                    bullet.move(toParent: worldNode)
                    bullet.position = bulletPos

                    
                }
                
                
                if(hasRiceBowl ?? false){
                    print("Adding a rice bowl to the scene")

                    let riceBowlPos = grass.centerOfTile(atColumn: col, row: row)
                    
                    let riceBowl = RiceBowl(healthValue: 2)
                    riceBowl.move(toParent: worldNode)
                    riceBowl.position = riceBowlPos


                }
                
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
                

                    let tileHeight = blackCorridors.tileSize.height
                    let tileWidth = blackCorridors.tileSize.width
                
                    let tileCenter = blackCorridors.centerOfTile(atColumn: col, row: row)
                    let tileSize = CGSize(width: tileWidth*1, height: tileHeight*1)
                    let cgRect = CGRect(x: tileCenter.x - tileWidth/2.0, y: tileCenter.y - tileHeight/2.0, width: tileWidth, height: tileHeight)
                    let pbNode = SKShapeNode(rect: cgRect)
                    pbNode.strokeColor = .clear
                    
                    let tilePB = SKPhysicsBody(rectangleOf: tileSize, center: tileCenter)
                    
                    tilePB.categoryBitMask = ColliderType.Obstacle.categoryMask
                    tilePB.collisionBitMask = ColliderType.Obstacle.collisionMask
                    tilePB.contactTestBitMask = ColliderType.Obstacle.contactMask
                    tilePB.isDynamic = false
                    tilePB.allowsRotation = false
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

    


    

