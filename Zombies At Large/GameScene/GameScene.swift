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
    var playerProximity: SKShapeNode!
    
    
    /** Current Level **/
    
    var currentGameLevel: GameLevel!
    
    var requiredCollectibles: Set<CollectibleSprite> = []

    var numberOfRequiredCollectibles: Int{
        return requiredCollectibles.count
    }
    
   
    var unrescuedCharacters: Set<RescueCharacter> = []
    
    var numberOfUnrescuedCharacters: Int{
        return unrescuedCharacters.count
    }
    
    
    
    var mustKillZombies: Set<Zombie> = []
    
    var numberOfMustKillZombies: Int{
        return mustKillZombies.count
    }
    
    var zombiesKilled: Int = 0
    
    var destinationZone: SKSpriteNode?
    
    /** Cached Sound Files **/
    
    var playMissionFailedSound: SKAction = SKAction.playSoundFileNamed("missionFailed", waitForCompletion: false)
    
    var playMissionAccomplishedSound: SKAction = SKAction.playSoundFileNamed("missionAccomplished", waitForCompletion: true)
    
    /** Node Layers **/
    
    var backgroundNode: SKNode!
    var overlayNode: SKNode!
    var worldNode: SKNode!
    var mainCameraNode: SKCameraNode!
    
    var hudNode: SKNode{
        return HUDManager.sharedManager.getHUD()
    }
    
    var safetyZone: SKSpriteNode?
    
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
    
    var rescueCharacter: RescueCharacter?

    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    
    var dialoguePanelIsShown: Bool = false
    
    var progressView: UIProgressView!
    
    var currentProgress: Float{
        
        return Float(currentProgressUnits/totalProgressUnits)
        
    }
    
    var currentProgressUnits: Int = 0{
        didSet{
            
            if progressView != nil{
                progressView.setProgress(self.currentProgress, animated: true)
            }
        }
    }
    
    var totalProgressUnits: Int{
        return 10
    }
    
    /** ***************  GameScene Initializers **/
    convenience init(currentGameLevel: GameLevel, progressView: UIProgressView) {
        self.init(size: UIScreen.main.bounds.size)
        self.currentGameLevel = currentGameLevel
        self.progressView = progressView
        self.currentProgressUnits = 0

        NotificationCenter.default.addObserver(self, selector: #selector(incrementZombieKillCount), name: Notification.Name(rawValue: "didKillZombieNotification"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(playerDeathHandler(notification:)), name: Notification.Name(rawValue: "playerDiedNotification"), object: nil)

     
        NotificationCenter.default.addObserver(self, selector: #selector(removeMustKillZombie(notification:)), name: NSNotification.Name(rawValue: Notification.Name.didKillMustKillZombieNotification), object: nil)
        
    }
    
    @objc func removeMustKillZombie(notification: Notification?){
        
        print("Removing a must kill zombie....")
        
        if let toRemoveZombie = self.mustKillZombies.first(where: {
            
            $0.name != notification?.userInfo?["zombieName"] as? String
            
        }){
            
            self.mustKillZombies.remove(toRemoveZombie)
            print("Must kill zombie removed!")
            print("Number of zombies left to kill is \(self.mustKillZombies.count)")
        }
        
        
        
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    override func didMove(to view: SKView) {
       
        for timeInterval in 1...10{
            
            let when = DispatchTime.now() + Double(timeInterval)
            
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didMakeProgressTowardsGameLoadingNotification), object: nil, userInfo: ["progressAmount": Float(0.05)])
                
            })
        }
      
        
        initializeBasicNodeLayers()
        
    
        loadMissionPanel()
        
       
        
        loadPlayer()
        
   
        initializePlayerProximity()
        
     
        loadCamera()
        
       
        loadZombieManager()
        
    
        
        loadFireButton()
        
      
        
        let xPosControls = UIScreen.main.bounds.width*0.3
        let yPosControls = -UIScreen.main.bounds.height*0.3
        loadControls(atPosition: CGPoint(x: xPosControls, y: yPosControls))
        
        loadBackground()
        loadHUD()
        

        let bomb = Bomb(scale: 1.00)
        bomb.move(toParent: worldNode)
        bomb.position = CGPoint(x: 150.0, y: 10.0)

        print("The unrescued character count is \(unrescuedCharacters.count)")
        
        
        
        let miniZombie = MiniZombie(zombieType: .zombie2, scale: 1.00, startingHealth: 3, hasDirectionChangeEnabled: true)
        miniZombie.move(toParent: worldNode)
        miniZombie.position = CGPoint(x: 100.0, y: 200.00)
        zombieManager.addDynamicZombie(zombie: miniZombie)

        let miniZombie2 = MiniZombie(zombieType: .zombie1, scale: 1.00, startingHealth: 1, hasDirectionChangeEnabled: true)
        miniZombie2.move(toParent: worldNode)
        miniZombie2.position = CGPoint(x: 100.0, y: 250.00)
        zombieManager.addDynamicZombie(zombie: miniZombie2)

        
        let miniZombie3 = MiniZombie(zombieType: .zombie1, scale: 1.00, startingHealth: 1, hasDirectionChangeEnabled: true)
        miniZombie3.move(toParent: worldNode)
        miniZombie3.position = CGPoint(x: -100.0, y: 250.00)
        zombieManager.addDynamicZombie(zombie: miniZombie3)
        
    
    }
    
    func loadCamera(){
        
        self.mainCameraNode = SKCameraNode()
        self.camera = mainCameraNode
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount": Float(0.05)])
        
    }
    
    func loadZombieManager(){
        zombieManager = ZombieManager(withPlayer: player, andWithLatentZombies: [])
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount":Float(0.05)])
    }
    
    func initializeBasicNodeLayers(){
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.00, dy: 0.00)
        
        self.backgroundColor = SKColor.cyan
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.backgroundNode = SKNode()
        self.addChild(backgroundNode)
        
        self.overlayNode = SKNode()
        self.overlayNode.zPosition = 20
        self.overlayNode.position = CGPoint(x: 0.00, y: 0.00)
        addChild(overlayNode)
        
        self.worldNode = SKNode()
        worldNode.zPosition = 10
        worldNode.position = CGPoint(x: 0.00, y: 0.00)
        worldNode.name = "world"
        addChild(worldNode)
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount":Float(0.05)])

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
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount":Float(0.05)])

        
    }
    
    func loadPlayer(){
      
        player = Player(playerType: .hitman1, scale: 1.50)
        player.position = CGPoint(x: 0.00, y: 0.00)
        player.zPosition = 5
        worldNode.addChild(player)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount":Float(0.05)])

    }
    
  
    func loadHUD(){
        hudNode.move(toParent: overlayNode)
        hudNode.zPosition = 35
        
        let xPos = -UIScreen.main.bounds.size.width*0.1
        let yPos = UIScreen.main.bounds.size.height*0.36
        hudNode.position = CGPoint(x: xPos, y: yPos)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount":Float(0.05)])

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
        
        
        if let winCondition = getWinConditionTest(),winCondition(){
            
            
            playerWinHandler()
            
        }
        
        /**
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
        **/
        
        zombieManager.update(withFrameCount: currentTime)

        
        lastUpdateTime = currentTime
        
        
        }
    

    override func didSimulatePhysics() {
        
        self.mainCameraNode.position = player.position
        overlayNode.position = self.mainCameraNode.position
        
        zombieManager.constrainActiveZombiesToPlayer()
        constraintRescuedCharactersToPlayer()
        checkSafetyZoneForRescueCharacterProximity()

    }
    
  
    
    override func didEvaluateActions() {
        updatePlayerProximity()
    }
    
   
    
    func initializePlayerProximity(){
        
        playerProximity = SKShapeNode(circleOfRadius: 10.0)
        playerProximity.strokeColor = .clear
        
        worldNode.addChild(playerProximity)

        playerProximity.position = self.position
        playerProximity.name = "playerProximity"
        
        
        let playerProximityPB = SKPhysicsBody(circleOfRadius: 100.0)
        playerProximityPB.affectedByGravity = false
        playerProximityPB.linearDamping = 0.00
        playerProximityPB.isDynamic = false
        playerProximityPB.allowsRotation = false
        playerProximityPB.categoryBitMask = ColliderType.PlayerProximity.categoryMask
        playerProximityPB.collisionBitMask = ColliderType.PlayerProximity.collisionMask
        playerProximityPB.contactTestBitMask = ColliderType.PlayerProximity.contactMask
        playerProximity.physicsBody = playerProximityPB
     
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount":Float(0.05)])

    }
    
    func updatePlayerProximity(){
        playerProximity.position = player.position
    }
    
    func centerOn(node: SKNode) {
        
        if let parentNode = node.parent,let cameraPositionInScene = node.scene?.convert(node.position, from: parentNode){
            
            parentNode.position = CGPoint(x: parentNode.position.x - cameraPositionInScene.x, y: parentNode.position.y - cameraPositionInScene.y)

        }
        
    }
    
    func constraintRescuedCharactersToPlayer(){
        for rescueCharacter in self.unrescuedCharacters{
            rescueCharacter.constrainToPlayer()
            
        }
    }
    
    func checkSafetyZoneForRescueCharacterProximity(){
        for rescueCharacter in self.unrescuedCharacters{
            if self.safetyZone != nil, self.safetyZone!.contains(rescueCharacter.position){
                
                print("The rescue character has entered the safety zone... Proceeding to remove the rescue character from the array of rescue character")
                
                self.unrescuedCharacters.remove(rescueCharacter)
                
                print("The current number of unrescued character is \(self.unrescuedCharacters.count)")
            }
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
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount":Float(0.05)])

        
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
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount":Float(0.05)])

    }
    
   
    
    @objc func playerDeathHandler(notification: Notification?){
        
        run(SKAction.run {
            
            self.showGameOverPrompt(withText1: "Health Level is too low", andWithText2: "Want to try again?")

        }, completion: {
            
            self.run(self.playMissionFailedSound)
        })
        
        print("Player has died!!")
    }
    
    func playerWinHandler(){
        run(SKAction.run {
            
            self.showGameWinPrompt(withText1: "Nice Job!", andWithText2: "Ready for more?")
            
            }, completion: {
                
                self.run(self.playMissionAccomplishedSound)
        })
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

    


    

