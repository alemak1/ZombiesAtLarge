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
import CoreData

class GameScene: SKScene{
    
    //MARK: User Profile
    
    var currentPlayerProfile: PlayerProfile?

    
    //MARK: Player/Game Statistics Tracker
    
    var gameLevelStatTracker: GameLevelStatTracker!

    
    //MARK: Player-Related Variables
    
    var player: Player!
    var playerProximity: SKShapeNode!
    

    //MARK: Variables: Current Level Properties
    
    var currentGameLevel: GameLevel!
    
    var zombiesKilled: Int = 0
    
    //MARK: *********** TRACKER DELEGATES
    
    lazy var requiredCollectiblesTrackerDelegate: RequiredCollectiblesTrackerDelegate? = {
        
        switch self.currentGameLevel!{
        case .Level1,.Level8:
            return RequiredCollectiblesTracker()
        default:
            return nil
        }
        
    }()
    
    
    
    lazy var unrescuedCharactersTrackerDelegate: UnrescuedCharacterTrackerDelegate? = {
        
        
        switch self.currentGameLevel!{
        case .Level2,.Level7,.Level8:
            return UnrescuedCharacterTracker()
        default:
            return nil
        }
        
        
    }()
    
    lazy var mustKillZombieTrackerDelegate: MustKillZombieTrackerDelegate? = {
        
        switch self.currentGameLevel!{
        case .Level4:
            return MustKillZombieTracker()
        default:
            return nil
        }
        
    }()
    
    /** Cached Sound Files **/
    
    var playMissionFailedSound: SKAction = SKAction.playSoundFileNamed("missionFailed", waitForCompletion: false)
    
    var playMissionAccomplishedSound: SKAction = SKAction.playSoundFileNamed("missionAccomplished", waitForCompletion: true)
    
    var playGrenadeLaunchSound: SKAction = SKAction.playSoundFileNamed("rumble3", waitForCompletion: true)
    
    /** Node Layers and Other Game-Level nodes **/
    
    var backgroundNode: SKNode!
    var overlayNode: SKNode!
    var worldNode: SKNode!
    var mainCameraNode: SKCameraNode!
    
    var hudNode: SKNode{
        return HUDManager.sharedManager.getHUD()
    }

    var safetyZone: SKSpriteNode?
    
    var destinationZone: SKSpriteNode?

    
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
    
    
    //MARK: UI Panels, Other UI Elements and Other Related Variables
    
    var controlButton: SKSpriteNode!
    
    var fireButton: SKNode!
    var menuOptionsButton: SKSpriteNode!
    var menuOptionsPanel: SKNode?
    var backToGameButton: SKSpriteNode?
    
    private var buttonsAreLoaded: Bool = false
    
    var dialoguePanelIsShown: Bool = false

    var bgNode: SKAudioNode!
    
    //MARK:  Zombie Manager
    
    var zombieManager: ZombieManager!

    //MARK: Timing-Related Variables
    
    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    
    
    /** ***************  GameScene Initializers **/
    convenience init(currentGameLevel: GameLevel) {
        self.init(size: UIScreen.main.bounds.size)
        self.currentGameLevel = currentGameLevel
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: failed to access the applicaton delegate")
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
   
        
        let fetchRequest = NSFetchRequest<PlayerProfile>(entityName: "PlayerProfile")
        let playerName = "Player1"
        fetchRequest.predicate = NSPredicate(format: "name == %@", playerName)
        
        guard let currentPlayerProfile = try! managedContext.fetch(fetchRequest).first else {
            fatalError("Error: failed to obtain a player profile for the game scene")
        }
        
            
        self.currentPlayerProfile = currentPlayerProfile
        self.gameLevelStatTracker = GameLevelStatTracker(gameLevel: currentGameLevel, playerProfile: currentPlayerProfile)
        print("Player 1 obtained")

        
        
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(incrementZombieKillCount), name: Notification.Name(rawValue: "didKillZombieNotification"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(playerDeathHandler(notification:)), name: Notification.Name(rawValue: "playerDiedNotification"), object: nil)

     
        NotificationCenter.default.addObserver(self, selector: #selector(removeMustKillZombie(notification:)), name: NSNotification.Name(rawValue: Notification.Name.didKillMustKillZombieNotification), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(setOffGrenade(notification:)), name: NSNotification.Name.GetDidSetOffGrenadeNotificationName(), object: nil)

        
    }
    
    @objc func setOffGrenade(notification: Notification?){
        
        run(playGrenadeLaunchSound, completion: {
            
            self.player.collectibleManager.removeCollectible(ofType: .Grenade)
            
        })
        
        
        for zombie in self.zombieManager.activeZombies{
            zombie.die(completion: {
                
                print("Zombie died from grenade launch!")
                
            })
        }
        
      
        
    }
    
    @objc func removeMustKillZombie(notification: Notification?){
        
        guard let mustKillZombieTracker = self.mustKillZombieTrackerDelegate, let toRemoveZombieName = notification?.userInfo?["zombieName"] as? String else {
            print("Error: found nil while attempting to load the must kill zombie delegate; no must kill zombie tracker delegate available")
            return
        }
        
        print("Removing a must kill zombie....")
        
        mustKillZombieTracker.removeMustKillZombie(withName: toRemoveZombieName)

        
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    override func didMove(to view: SKView) {
       
        print("ALL GAME STAT REVIEW UP TO DATE: ")

        
        if let gameStatReviews = self.gameLevelStatTracker.getAllGameLevelStatReviews(){
        
            for gameStatReview in gameStatReviews{
                gameStatReview.showGameLevelStatReviewSummary()
            }
        }
        
        
        print("GAME STAT REVIEW FOR CURRENT PLAYER PROFILE: ")
        
        if let gameSessions  = self.gameLevelStatTracker.getAllGameLevelStatReviewsForCurrentPlayerProfile(){
            
            for gameSession in gameSessions{
                if let statReview = gameSession as? GameLevelStatReview{
                    statReview.showGameLevelStatReviewSummary()
                }
            }
        }
        
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
        

        let camera = CollectibleSprite(collectibleType: .Camera)
        camera.move(toParent: worldNode)
        camera.position = CGPoint(x: 150.0, y: 10.0)

        if let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate{
            print("The unrescued character count is \(unrescuedCharactersTracker.numberOfUnrescuedCharacters)")

        }
        
        
        
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
        self.gameLevelStatTracker.numberOfZombiesKilled = self.zombiesKilled
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
        
        
        if let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate,let safetyZone = self.safetyZone{
            
            unrescuedCharactersTracker.constraintRescuedCharactersToPlayer()
            unrescuedCharactersTracker.checkSafetyZoneForRescueCharacterProximity(safetyZone: safetyZone)

            
        }

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
                
                self.gameLevelStatTracker.totalValueOfCollectibles = self.player.collectibleManager.getTotalMonetaryValueOfAllCollectibles()
                self.gameLevelStatTracker.totalNumberOfCollectibles = self.player.collectibleManager.getTotalNumberOfAllItems()
                self.gameLevelStatTracker.numberOfBulletsFired = self.player.getNumberOfBulletsFired()
                self.gameLevelStatTracker.saveGameLevelStats()
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
 
         **/

    


    

