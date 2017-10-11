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



/**
 
     For the GameScene snapshot, need to save the following information:
     - PlayerSnaphot
     - WorldNode
 **/



class GameScene: BaseScene{
    
        
    //MARK: Reference to saved game object used to load a previously saved level

    var savedGame: SavedGame? = nil
    

    //MARK: Variables: Current Level Properties
    
    var currentGameLevel: GameLevel!
    
    
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
    
    
    var unrescuedCharacters: Set<RescueCharacter>?{
        return self.unrescuedCharactersTrackerDelegate?.getUnrescuedCharacters()
    }
  
    var requiredCollecribles: Set<CollectibleSprite>?{
        return self.requiredCollectiblesTrackerDelegate?.getRequiredCollectibles()
    }
    
    var mustKillZombies: Set<Zombie>?{
        return self.mustKillZombieTrackerDelegate?.getMustKillZombies()
    }
    
    var hudNode: SKNode{
        return HUDManager.sharedManager.getHUD()
    }
    
    var hudLoadingLevel = 0

    var safetyZone: SKSpriteNode?
    
    var destinationZone: SKSpriteNode?

    var cameraMissionPrompt: SKSpriteNode?
    
    /** Mission Panel **/
    
    lazy var missionPanel: SKNode? = {
        
        print("Loading mission panel....")
        
        let missionPanel = UIPanelGenerator.GetMissionPanelFor(gameLevel: self.currentGameLevel)
      
        return missionPanel
        
    }()
    
    //MARK: GameSaver
    
    var gameSaver: GameSaver!
    
   
    //MARK: UI Panels, Other UI Elements and Other Related Variables
    
    var menuOptionsButton: SKSpriteNode!
    var menuOptionsPanel: SKNode?
    var backToGameButton: SKSpriteNode?
  
    private var buttonsAreLoaded: Bool = false
    
    var dialoguePanelIsShown: Bool = false

    var bgNode: SKAudioNode!
    
   
    var npcAvailableForDialogue: Bool = true
    var npcPostContactBufferTimeInterval = 2.00
    var npcPostContactBufferFrameCount = 0.00
    var npcBufferCounterLastUpdateTime = 0.00
  
    var shouldUpatePlayer: Bool = false
    
    /** ***************  GameScene Initializers **/
    
    convenience init(playerProfile: PlayerProfile, savedGame: SavedGame) {
        
        print("Initializing game scene from saved game...")
        
        self.init(size: UIScreen.main.bounds.size)
        
        
        self.savedGame = savedGame

        let gameLevelRawValue = Int(savedGame.level)
        let gameLevel = GameLevel(rawValue: gameLevelRawValue)!
        
        self.currentPlayerProfile = playerProfile
        self.currentGameLevel = gameLevel
        self.frameCount = savedGame.frameCount
    
        
        self.gameLevelStatTracker = GameLevelStatTracker(gameLevel: gameLevel, playerProfile: playerProfile)

        self.gameSaver = GameSaver(withGameScene: self)

    }
    
    convenience init(currentGameLevel: GameLevel, playerProfile: PlayerProfile) {
        

        self.init(size: UIScreen.main.bounds.size)
        
        self.currentGameLevel = currentGameLevel
        self.currentPlayerProfile = playerProfile
        self.gameLevelStatTracker = GameLevelStatTracker(gameLevel: currentGameLevel, playerProfile: playerProfile)

        self.gameSaver = GameSaver(withGameScene: self)


    }
    
    @objc func updateHUDLoadingLevel(notification: Notification?){
        
        if let hudLoadingLevel = notification?.userInfo?["loadingLevel"] as? Int{
            self.hudLoadingLevel = hudLoadingLevel
            
        
        }
    }
    
    @objc func updateHUDLoadingLevelBasic(notification: Notification?){
        
        if let hudLoadingLevel = notification?.userInfo?["loadingLevel"] as? Int{
            self.hudLoadingLevel = hudLoadingLevel
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
        
        
        let didKillZombieNotificationName =  NSNotification.Name(rawValue: Notification.Name.didKillMustKillZombieNotification)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeMustKillZombie(notification:)), name: didKillZombieNotificationName, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(updateHUDLoadingLevel(notification:)), name: Notification.Name.GetDidFinishLoadingHUDNotification(), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustPlayerMonitoringStatus(notification:)), name: Notification.Name.GetDidActivateCollectibleNotificationName(), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    @objc func adjustPlayerMonitoringStatus(notification: Notification?){
        
        if let userInfo = notification?.userInfo, let rawValue = userInfo["collectibleRawValue"] as? Int,let isActive = userInfo["isActive"] as? Bool{
            
            let collectibleType = CollectibleType(rawValue: rawValue)!
            
            if(collectibleType == CollectibleType.Syringe){
                
                
                shouldUpatePlayer = isActive ? true : false
            }
        }
    
    }
    
    override func didMove(to view: SKView) {
       super.didMove(to: view)
        
        /** If the Game Scene has not been loaded from a saved game, then initialize it from scratch **/
        

        if(self.savedGame == nil){

            loadMissionPanel()
            loadPlayer()
            
            loadZombieManager()
            loadBackground()

            loadGameControls()
            addHUDNode()
     
        } else {
            
            
            guard let savedGame = self.savedGame else {
                print("Error: found nil while unwrapping saved game object")
                return
            }
            
            
            loadMissionPanel()
            loadPlayer(fromSavedGame: savedGame)
            loadPlayerCollectibles(forSavedGame: savedGame)
            loadBackground()
            loadGameControls()
            loadRequiredCollectibles(fromSavedGame: savedGame)
            loadGeneralCollectibles(fromSavedGame: savedGame)
            loadRescueCharacters(forSavedGame: savedGame)
            loadZombieManager()
            loadZombies(fromSavedGame: savedGame)
            loadMustKillZombies(forSavedGame: savedGame)
            addHUDNodeForSavedGame()
        
        }
     
    }
    
    
    func loadPlayer(fromSavedGame savedGame: SavedGame){
        let playerStateSnapshot = savedGame.playerSnapshot as! PlayerStateSnapShot
        let player = Player(playerProfile: self.currentPlayerProfile!, playerStateSnapshot: playerStateSnapshot)
        
        player.move(toParent: worldNode)
        self.player = player
    }
    
    func loadPlayerCollectibles(forSavedGame savedGame: SavedGame){
        
        print("Loading player collectibles...")
        
        
        if let playerCollectibleConfigs = savedGame.playerCollectibles?.allObjects as? [PlayerCollectibleConfiguration]{
            
            print("Getting player collectible configurations...")
            
            let collectibles = playerCollectibleConfigs.map({$0.getRestoredCollectibleFromPlayerCollectibleConfiguration()})
        
            self.player.addCollectibles(collectibles: collectibles)
        
        }
    }
    
    func loadRescueCharacters(forSavedGame savedGame: SavedGame){
       
        print("About to load unrescued characters...")
        
        if let rescueCharConfigurations = savedGame.unrescuedCharacters as? Set<RescueCharConfiguration>{
            
            var rescueCharacters = [RescueCharacter]()
            
            rescueCharConfigurations.forEach({
                
                rescueCharConfiguration in
                
                print("Retrieving rescue character configuration...\(rescueCharConfiguration.description)")
                
                let nonplayerCharRawValue = Int(rescueCharConfiguration.nonplayerTypeCharacter)
                let nonplayerCharType = NonplayerCharacterType(rawValue: nonplayerCharRawValue)!
                
                let newRescueCharacter = RescueCharacter(withPlayer: self.player, nonPlayerCharacterType: nonplayerCharType)
                
                newRescueCharacter.hasBeenRescued = rescueCharConfiguration.hasBeenRescued
                
                let compassDirectionRawValue = Int(rescueCharConfiguration.compassDirectionRawValue)
                newRescueCharacter.compassDirection = CompassDirection(rawValue: compassDirectionRawValue)!
                
                rescueCharacters.append(newRescueCharacter)
                newRescueCharacter.move(toParent: worldNode)
            })
            
            
            let set = NSSet(array: rescueCharacters) as! Set<RescueCharacter>
            
            self.unrescuedCharactersTrackerDelegate = UnrescuedCharacterTracker(with: set)
            
   
        }
    
    }
        
        //MARK: ******* NOT YET IMPLEMENTED
    func loadMustKillZombies(forSavedGame savedGame: SavedGame){
       
        print("About to load unrescued characters...")
        
        if let zombieSnapShots = savedGame.mustKillZombies as? Set<ZombieSnapshot>{
            
            let reloadedZombies = zombieSnapShots.map({$0.getZombieRestoredFromZombieSnapshot()})

            reloadedZombies.forEach({
                $0.move(toParent: worldNode)
                
            })
            
            let set = NSSet(array: reloadedZombies) as! Set<Zombie>
            
            self.mustKillZombieTrackerDelegate = MustKillZombieTracker(withMustKillZombies: set)
            
        }
    }
    
    func loadZombies(fromSavedGame savedGame: SavedGame){
    
        
        guard let zombieSnapshots = savedGame.zombieSnapshotGroup?.zombieSnapshots?.allObjects as? [ZombieSnapshot]  else {
            fatalError("Error: found nil while attempting to unwrap the zombie snapshot set associated with this game level")
        }
        
        print("Loading zombies based on zombie snapshots from saved game...")
        
        zombieSnapshots.forEach({
            
            zombieSnapshot in
            
            print("Retrieving zombie snapshot from saved game...\(zombieSnapshot.debugDescription)")
            
            let reloadedZombie = zombieSnapshot.getZombieRestoredFromZombieSnapshot()
            
            if(zombieSnapshot.isActive){
                reloadedZombie.activateZombie()
                zombieManager.activateZombie(zombie: reloadedZombie)
            }
            
            reloadedZombie.move(toParent: worldNode)
          
            
            print("Reloaded zombie initialized.  Now positioned at x: \(reloadedZombie.position.x), y: \(reloadedZombie.position.y)")
            
        })
        
        
        
    }
    
    func loadGeneralCollectibles(fromSavedGame savedGame: SavedGame){
        
        if let generalCollectibles = savedGame.collectibleSpriteSnapshotGroup?.collectibleSpriteSnapshots as? Set<CollectibleSpriteSnapshot>{
            
            let collectibleSprites = generalCollectibles.map({
                
                collectibleSpriteSnapshot in
                
                return collectibleSpriteSnapshot.getCollectibleSpriteRestoredFromSnapshot()
                
            })
            
            
            
            collectibleSprites.forEach({
                
                collectibleSprite in
                
                collectibleSprite.move(toParent: worldNode)
                
            })
            
        }
    }
    
    func loadRequiredCollectibles(fromSavedGame savedGame: SavedGame){
        if let requiredCollectibles = savedGame.requiredCollectibles as? Set<CollectibleSpriteSnapshot>{
            
            let collectibleSprites = requiredCollectibles.map({
                
                collectibleSpriteSnapshot in
                
                return collectibleSpriteSnapshot.getCollectibleSpriteRestoredFromSnapshot()
                
            })
            
            
            let set = NSSet(array: collectibleSprites) as! Set<CollectibleSprite>
            
            self.requiredCollectiblesTrackerDelegate = RequiredCollectiblesTracker(with: set)
            
            collectibleSprites.forEach({
                
                collectibleSprite in
                
                collectibleSprite.move(toParent: worldNode)
                
            })
            
        }

    }
    
    override func loadPlayer() {
        
            let playerProfile = self.currentPlayerProfile!
            player = Player(playerProfile: playerProfile)
            player.position = CGPoint(x: 0.00, y: 0.00)
            player.zPosition = 5
            worldNode.addChild(player)
    
    }
    
    
    func loadTestItems(){
        let camera = CollectibleSprite(collectibleType: .Camera)
        camera.move(toParent: worldNode)
        camera.position = CGPoint(x: 150.0, y: 10.0)
        
        
        
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
        
        let cameraMan = NonplayerCharacter(nonPlayerCharacterType: .Hitman, andName: "CameraMan")
        cameraMan.move(toParent: worldNode)
        cameraMan.position = CGPoint(x: -100, y: -250.00)
        cameraMan.setTargetPictureString()
        
    }
    
    func loadGameControls(){
        let xPosControls = UIScreen.main.bounds.width*0.3
        let yPosControls = -UIScreen.main.bounds.height*0.3
        let point = CGPoint(x: xPosControls, y: yPosControls)
        loadControls(atPosition: point)
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
    
    
    func loadHUDViaOperationQueue(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            addHUDNode()
            return
        }
        
        appDelegate.hudLoadingOperationQueue.qualityOfService = .userInitiated
        
    }
  
    func loadHUDWithProgrammedDelays(){
        
        print("HUD loading level is \(self.hudLoadingLevel)")
        switch self.hudLoadingLevel {
        case 4:
            //HUD is fully loaded
            print("HUD loading level at 4: HUD is fully loaded")
            self.addHUDNode()
            break
        case 3:
            //HUD almost fully loaded
            print("HUD loading level at 3: HUD is almost fully loaded")
            DispatchQueue.main.asyncAfter(deadline:.now() + 1.00, execute: {
                self.addHUDNode()
            })
            break
        case 2:
            //HUD is halfway loaded
            print("HUD loading level at 2: HUD is almost fully loaded")
            DispatchQueue.main.asyncAfter(deadline:.now() + 2.00, execute: {
                self.addHUDNode()
            })
            break
        case 1:
            //HUS is partially loaded
            print("HUD loading level at 1: HUD is almost fully loaded")
            DispatchQueue.main.asyncAfter(deadline:.now() + 2.00, execute: {
                self.addHUDNode()
            })
            break
        case 0:
            //HUD has not started loading
            print("HUD loading level at 0: HUD is almost fully loaded")
            DispatchQueue.main.asyncAfter(deadline:.now() + 4.00, execute: {
                self.addHUDNode()
            })
            break
        default:
            addHUDNode()
            break
        }
        
      

    }
    
    
    func addHUDNode(){
        print("Now adding HUD...HUD loading level is at \(hudLoadingLevel)")
        hudNode.move(toParent: overlayNode)
        hudNode.zPosition = 35
        
        let xPos = -UIScreen.main.bounds.size.width*0.1
        let yPos = UIScreen.main.bounds.size.height*0.36
        hudNode.position = CGPoint(x: xPos, y: yPos)

        
    }
   
    func addHUDNodeForSavedGame(){
        
        HUDManager.sharedManager.updateBulletCount(withUnits: self.player.getCurrentHealth())
        HUDManager.sharedManager.updateHealthCount(withUnits: self.player.getNumberOfBulletsFired())
        
        addHUDNode()
        
   
      
    }
  
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        

        super.update(currentTime)

        if(shouldUpatePlayer){
            player.update(currentTime: currentTime)
        }
        
        
        /**
        if(!npcAvailableForDialogue){
            
            if(npcBufferCounterLastUpdateTime == 0){
                npcBufferCounterLastUpdateTime = currentTime
            }
            
            npcPostContactBufferFrameCount += currentTime - npcBufferCounterLastUpdateTime
            
            print("The npcPostContactBufferFrameCount is \(npcPostContactBufferFrameCount)")
            
            if npcPostContactBufferFrameCount > npcPostContactBufferTimeInterval{
            
                npcPostContactBufferFrameCount = 0
                npcAvailableForDialogue = true
            }
            
            npcBufferCounterLastUpdateTime = currentTime
        } **/
}
    

    override func didSimulatePhysics() {
        
       super.didSimulatePhysics()
                
        
        if let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate{
            
            unrescuedCharactersTracker.constraintRescuedCharactersToPlayer()
           
            if let safetyZone = self.safetyZone{
                unrescuedCharactersTracker.checkSafetyZoneForRescueCharacterProximity(safetyZone: safetyZone)
            }
            
        }
        
        
       

    }
    
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

    
  
    
    override func didEvaluateActions() {
        
        super.didEvaluateActions()
    }
    
   
    
    override func getWinConditionTest() -> (() -> Bool)?{
        
        switch self.currentGameLevel! {
        case .Level1:
            return {
                
                guard let requiredCollectiblesTracker = self.requiredCollectiblesTrackerDelegate else {
                    fatalError("Error: found nil while unwrapping the required collectibles tracker delegate")
                }
                
                return requiredCollectiblesTracker.numberOfRequiredCollectibles <= 0
                
            }
        case .Level2:
            
            guard let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate else {
                fatalError("Error: found nil while unwrapping the unrescued characters tracker delegate")
                
            }
            return { return unrescuedCharactersTracker.numberOfUnrescuedCharacters <= 0 }
        case .Level3:
            return { return self.player.collectibleManager.getTotalMetalContent() > 200 }
        case .Level4:
            return {
                
                guard let zombieTracker = self.mustKillZombieTrackerDelegate else {
                    fatalError("Error: found nil while attempting to unwrap the must kill zombie tracker delegate")
                }
                
                return zombieTracker.getNumberOfUnkilledZombies() <= 0
                
            }
        case .Level5:
            return { return self.player.collectibleManager.getTotalMonetaryValueOfAllCollectibles() > 2000 }
        case .Level6:
            return {
                
                guard let destinationZone = self.destinationZone else {
                    fatalError("No destination zone initialized for this level")
                }
                
                return destinationZone.contains(self.player.position)
                
            }
        case .Level7:
            return {
                
                guard let zombieTracker = self.mustKillZombieTrackerDelegate else {
                    fatalError("Error: found nil while attempting to unwrap the must kill zombie tracker delegate")
                }
                
                guard let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate else {
                    fatalError("Error: found nil while unwrapping the unrescued characters tracker delegate")
                    
                }
                
                return zombieTracker.getNumberOfUnkilledZombies() <= 0 && unrescuedCharactersTracker.numberOfUnrescuedCharacters <= 0
            }
        case .Level8:
            return {
                
                guard let requiredCollectiblesTracker = self.requiredCollectiblesTrackerDelegate else {
                    fatalError("Error: found nil while unwrapping the required collectibles tracker delegate")
                }
                
                guard let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate else {
                    fatalError("Error: found nil while unwrapping the unrescued characters tracker delegate")
                    
                }
                
                return unrescuedCharactersTracker.numberOfUnrescuedCharacters <= 0 && requiredCollectiblesTracker.numberOfRequiredCollectibles <= 0
            }
        case .Level9:
            return {
                
                guard let zombieTracker = self.mustKillZombieTrackerDelegate else {
                    fatalError("Error: found nil while attempting to unwrap the must kill zombie tracker delegate")
                }
                
                return zombieTracker.getNumberOfUnkilledZombies() <= 0
            }
        case .Level10:
            return {
                
                guard let zombieTracker = self.mustKillZombieTrackerDelegate else {
                    fatalError("Error: found nil while attempting to unwrap the must kill zombie tracker delegate")
                }
                
                return zombieTracker.getNumberOfUnkilledZombies() <= 0
            }
        default:
            print("No win condition available for this level ")
        }
        
        return nil
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


/**
 
 /**
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
 **/

**/
    

