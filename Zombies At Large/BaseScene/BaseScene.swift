//
//  BaseScene.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CoreData

class BaseScene: SKScene{
    
    //MARK: User Profile
    
    var currentPlayerProfile: PlayerProfile?
    
    
    //MARK: Player/Game Statistics Tracker
    
    var gameLevelStatTracker: StatTracker!

    
    /** Cached Sound Files **/
    
    var playMissionFailedSound: SKAction = SKAction.playSoundFileNamed("missionFailed", waitForCompletion: false)
    
    var playMissionAccomplishedSound: SKAction = SKAction.playSoundFileNamed("missionAccomplished", waitForCompletion: true)
    
    var playGrenadeLaunchSound: SKAction = SKAction.playSoundFileNamed("rumble3", waitForCompletion: true)
    
    /** Reference to Player **/
    
    var player: Player!
    var playerProximity: SKShapeNode!
    var fireButton: SKShapeNode!
    
    /** Node Layers **/
    
    var worldNode: SKNode!
    var overlayNode: SKNode!
    var backgroundNode: SKNode!
    
    /** Tile Backgrounds **/
    
    var grassTileMap: SKTileMapNode!
    var blackCorridorTileMap: SKTileMapNode!
    var woodFloorTileMap: SKTileMapNode!
    
    var mainCameraNode: SKCameraNode!
    
    var zombiesKilled: Int = 0

    //MARK:  Zombie Manager
    
    var zombieManager: ZombieManager!
    
    //MARK: Timing-Related Variables
    
    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    
    override init(size: CGSize) {
    
        super.init(size: size)
        
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
        
        print("Player 1 obtained")
        
        NotificationCenter.default.addObserver(self, selector: #selector(incrementZombieKillCount), name: Notification.Name(rawValue: "didKillZombieNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDeathHandler(notification:)), name: Notification.Name(rawValue: "playerDiedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setOffGrenade(notification:)), name: NSNotification.Name.GetDidSetOffGrenadeNotificationName(), object: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        initializeBasicNodeLayers()
        initializePlayerProximity()
        loadCamera()
        loadPlayer()
        loadZombieManager()
        loadFireButton()
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if(lastUpdateTime == 0){
            lastUpdateTime = currentTime;
        }
        
        frameCount = currentTime - lastUpdateTime;
        
        
        if let winCondition = getWinConditionTest(),winCondition(){
            
            
            playerWinHandler()
            
        }
        
        zombieManager.update(withFrameCount: currentTime)

        lastUpdateTime = currentTime

    }
    
    override func didEvaluateActions() {
        super.didEvaluateActions()
        
        updatePlayerProximity()

    }
    
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        
        self.mainCameraNode.position = player.position
        overlayNode.position = self.mainCameraNode.position
        
        zombieManager.constrainActiveZombiesToPlayer()

        
    }
    
    func loadCamera(){
        
        self.mainCameraNode = SKCameraNode()
        self.camera = mainCameraNode
        
        
    }
    
    func loadPlayer(){
        
        player = Player(playerType: .hitman1, scale: 1.50)
        player.position = CGPoint(x: 0.00, y: 0.00)
        player.zPosition = 5
        worldNode.addChild(player)
        
        
    }
    
    func initializeBasicNodeLayers(){
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.00, dy: 0.00)
        
        self.backgroundColor = SKColor.cyan
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        if(worldNode == nil){
            worldNode = SKNode()
        }
        
        if(backgroundNode == nil){
            backgroundNode = SKNode()
        }
        
        if(overlayNode == nil){
            overlayNode = SKNode()
        }
        
        
        worldNode.position = CGPoint.zero
        worldNode.zPosition = 10
        worldNode.name = "world"
        worldNode.move(toParent: self)
        
        
        backgroundNode.position = CGPoint.zero
        backgroundNode.move(toParent: self)
        
        
        overlayNode.position = CGPoint.zero
        overlayNode.zPosition = 20
        overlayNode.move(toParent: self)
        
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
        
        
    }
    
    func updatePlayerProximity(){
        playerProximity.position = player.position
    }
    
    func loadZombieManager(){
        zombieManager = ZombieManager(withPlayer: player, andWithLatentZombies: [])
        
        
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
    
    @objc func incrementZombieKillCount(){
        self.zombiesKilled += 1
        self.gameLevelStatTracker.numberOfZombiesKilled = self.zombiesKilled
        print("Total number of zombies currently killed is: \(self.zombiesKilled)")
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
    
    
    public func showGameWinPrompt(withText1 text1: String, andWithText2 text2: String){
        
        if let gameWinPrompt = UIPanelGenerator.GetGameWinPrompt(withText1: text1, andWithText2: text2){
            
            gameWinPrompt.move(toParent: overlayNode)
            gameWinPrompt.position = CGPoint.zero
            
            isPaused = true
            worldNode.isPaused = true
            
        } else {
            print("Error: Failed to load the mission completed prompt")
        }
    }
    
    public func showGameOverPrompt(withText1 text1: String, andWithText2 text2: String){
        
        if let gameOverPrompt = UIPanelGenerator.GetGameOverPrompt(withText1: text1, andWithText2: text2){
            
            gameOverPrompt.move(toParent: overlayNode)
            gameOverPrompt.position = CGPoint.zero
            
            isPaused = true
            worldNode.isPaused = true
            
        } else {
            print("Error: Failed to load the mission failed prompt")
        }
    }
    
    func getWinConditionTest() -> (() -> Bool)?{
        return nil
    }
    
}

extension BaseScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
