//
//  Player.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class PlayerStateSnapShot: NSObject, NSCoding{
    
    var healthLevel: Int
    var numberOfBullets: Int
    var compassOrientation: CompassDirection
    var position: CGPoint
    var currentVelocity: CGVector
    var playerType: PlayerType
    var collectibleManager: CollectibleManager
    
   
    
    init(playerType: PlayerType, healthLevel: Int, numberOfBullets: Int, compassOrientation: CompassDirection, position: CGPoint, currentVelocity: CGVector, collectibleManager: CollectibleManager) {
        
        self.playerType = playerType
        self.healthLevel = healthLevel
        self.numberOfBullets = numberOfBullets
        self.compassOrientation = compassOrientation
        self.position = position
        self.currentVelocity = currentVelocity
        self.collectibleManager = collectibleManager
        
        super.init()
        
    }
    
    
    

    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.position, forKey: "position")
        aCoder.encode(self.currentVelocity, forKey: "currentVelocity")
        aCoder.encode(self.healthLevel, forKey: "healthLevel")
        aCoder.encode(self.numberOfBullets, forKey: "numberOfBullets")
        
       aCoder.encode(self.playerType.getIntegerValue(), forKey: "playerType")
       aCoder.encode(Int64(self.compassOrientation.rawValue), forKey: "compassDirection")
       aCoder.encode(self.collectibleManager, forKey: "collectibleManager")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        let position = aDecoder.decodeCGPoint(forKey: "position")
        self.position = position
        
        print("Initialize player with a position of x: \(position.x) and y: \(position.y) ")
        
        let currentVelocity = aDecoder.decodeCGVector(forKey: "currentVelocity")
        self.currentVelocity = currentVelocity
    
        print("Initializing player with a current velocity of dx: \(currentVelocity.dx) and dy: \(currentVelocity.dy)")
        
        
        let health = aDecoder.decodeInteger(forKey: "healthLevel")
        self.healthLevel = health
        
        print("Initializing player with a health of \(health)")
        
        
        let numberOfBullets = aDecoder.decodeInteger(forKey: "numberOfBullets")
        self.numberOfBullets = numberOfBullets
        
        print("Initializing player with \(numberOfBullets) bullets")
        
    
        
        self.compassOrientation = CompassDirection(rawValue: Int(aDecoder.decodeInt64(forKey: "compassDirection"))) ?? .east
        

        let playerInt = aDecoder.decodeInteger(forKey: "playerType")
        self.playerType = PlayerType(withIntegerValue: playerInt)
        print("Initializing player with player type of \(playerInt)")
        
        self.collectibleManager = (aDecoder.decodeObject(forKey: "collectibleManager") as? CollectibleManager) ?? CollectibleManager()
        
    
    }
}

class Player: Shooter{
    
    //MARK: Store Properties and Variables
    
    /** The Player Profile for this player **/
    
    var playerProfile: PlayerProfile!

    var playerUpgradeObject: CollectibleType?{
        
        guard let playerProfile = self.playerProfile else { return nil }
        
        let rawValue = Int(playerProfile.upgradeCollectible)
        
        return CollectibleType(rawValue: rawValue)
        
    }
    
    
    var playerSpecialWeapon: CollectibleType?{
        
        guard let playerProfile = self.playerProfile else { return nil }
        
        let rawValue = Int(playerProfile.specialWeapon)
        
        return CollectibleType(rawValue: rawValue)
        
    }
    
    
    var pickedImage: UIImage?{
        didSet{
            if(pickedImage != nil){
                //post a notification that is sent to the NPC
                print("Player has picked an image. Procedding to send notification to the NPC")
                NotificationCenter.default.post(name: Notification.Name.GetDidSetPickedPictureForPlayer(), object: self, userInfo: nil)
            }
        }
    }
    
    lazy var playerStateSnapShot: PlayerStateSnapShot = {
        
        let velocity = self.physicsBody?.velocity ?? CGVector.zero
        
        let playerTypeRawValue = Int(playerProfile.playerType)
        let playerType = PlayerType(withIntegerValue: playerTypeRawValue)
        
        return PlayerStateSnapShot(playerType: playerType, healthLevel: self.health, numberOfBullets: self.numberOfBullets, compassOrientation: self.compassDirection, position: self.position, currentVelocity: velocity, collectibleManager: self.collectibleManager)
        
    }()
    
   
    
    private var playerType: PlayerType
    
    
    private var health: Int = 15{
        didSet{
            if self.health < 0{
                let playerDiedNotification = Notification.Name(rawValue: "playerDiedNotification")
                NotificationCenter.default.post(name: playerDiedNotification, object: nil)
            }
        }
    }
    
    private var numberOfBullets: Int = 30
    
    private var numberOfBulletsFired: Int = 0
    
    var hasSpecialBullets: Bool{
        
        return self.collectibleManager.getActiveStatusFor(collectibleType: .SilverBullet)
        
    }
    
    var updatingBulletCount = false
    var isTemporarilyInvulnerable = false
    var numberOfTimesAcquired = 0
    
    var isInvulnerable: Bool = false
    
    lazy var frameCount: Double = 0.00
    
    var lastUpdateTime: Double = 0.00
    var invulnerabilityInterval = 10.00
    
    func update(currentTime: TimeInterval){
        
        if(lastUpdateTime == 0.00){
            lastUpdateTime = currentTime
        }
        
        
        
        if(isInvulnerable){
            
            frameCount += currentTime - lastUpdateTime
            
            print("Player is invulnerable, frameCount is now \(frameCount)")
            
            if(frameCount > invulnerabilityInterval){
                
                
                let userInfo: [String:Any] = [
                    "collectibleRawValue":CollectibleType.Syringe.rawValue,
                    "isActive": false
                ]
                
                NotificationCenter.default.post(name: Notification.Name.GetDidActivateCollectibleNotificationName(), object: nil, userInfo: userInfo)
                    
                collectibleManager.removeCollectible(ofType: .Syringe)
                
                frameCount = 0.00
            }
            
        }
        
        lastUpdateTime = currentTime
    }
    
    //MARK:     ********* HELPER FUNCTIONS
    
    override var configureBulletBitmasks: ((inout SKPhysicsBody) -> Void)?{
        
        return {(bulletPB: inout SKPhysicsBody) in
            
            if(!self.hasSpecialBullets){
                bulletPB.categoryBitMask = ColliderType.PlayerBullets.categoryMask
                bulletPB.collisionBitMask = ColliderType.PlayerBullets.collisionMask
                bulletPB.contactTestBitMask = ColliderType.PlayerBullets.contactMask
                
            } else {
                
                bulletPB.categoryBitMask = ColliderType.SpecialBullets.categoryMask
                bulletPB.collisionBitMask = ColliderType.SpecialBullets.collisionMask | ~ColliderType.Obstacle.categoryMask
                bulletPB.contactTestBitMask = ColliderType.SpecialBullets.contactMask
            }
            
        }
    }

    func configurePlayerState(withPlayerStateSnapshot playerStateSnapshot: PlayerStateSnapShot){
        
        self.position = playerStateSnapshot.position
        self.playerType = playerStateSnapshot.playerType
        self.compassDirection = playerStateSnapshot.compassOrientation
        self.health = playerStateSnapshot.healthLevel
        self.numberOfBullets = playerStateSnapshot.numberOfBullets
        self.physicsBody?.velocity = playerStateSnapshot.currentVelocity
        
    }
  
    
    override var playFiringSound: SKAction
    {
        return SKAction.playSoundFileNamed("laser1", waitForCompletion: true)
    }
    
    var playCollectItemSound: SKAction{
        return SKAction.playSoundFileNamed("coin5", waitForCompletion: false)
    }
    
    override var appliedUnitVector: CGVector{
    
        let xUnitVector = cos(compassDirection.zRotation)
        let yUnitVector = sin(compassDirection.zRotation)
        
        return CGVector(dx: xUnitVector, dy: yUnitVector)
    }
    
    var compassDirection: CompassDirection{
        didSet{
            
            guard oldValue != compassDirection else { return }
            
            let rotation = ((compassDirection.zRotation - oldValue.zRotation) <= CGFloat.pi) && (compassDirection.zRotation > oldValue.zRotation)  ? (compassDirection.zRotation - oldValue.zRotation) : -(oldValue.zRotation - compassDirection.zRotation)
            
       
            run(SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.10))
            

            }
        }
    
    public func getCurrentHealth() -> Int{
        return self.health
    }
    
    public func getCurrentNumberOfBullets() -> Int{
        return self.numberOfBullets
    }
    
    
 
    var collectibleManager = CollectibleManager()
   
    
    func equipPlayerWithSpecialWeapon( ){
        
        print("Equiping player with special weapon...")
        
        if let specialWeaponType = self.playerSpecialWeapon{
            
            let specialWeapon = Collectible(withCollectibleType: specialWeaponType)
            collectibleManager.addCollectibleItem(newCollectible: specialWeapon, andWithQuantityOf: 5)
            print("Player has been equipped with \(specialWeapon.getCollectibleName()) for special weapon")
        }
    }
    
    func addCollectibles(collectibles: [Collectible]){
        collectibles.forEach({ self.collectibleManager.addCollectibleItem(newCollectible: $0) })
    }
    
    func addCollectible(collectible: Collectible){
        
        self.collectibleManager.addCollectibleItem(newCollectible: collectible)
    }
    
    /*** If the player upgrade object is contacted, then the player's carrying capacity will increase by increasing increments **/
    
    func handleUpgradeObjectContact(collectibleSprite: CollectibleSprite){
        
        if let playerUpgradeObject = self.playerUpgradeObject,collectibleSprite.collectibleType == playerUpgradeObject{
            
            
                self.numberOfTimesAcquired += 1
            
                print("Player has acquired upgrade object \(self.numberOfTimesAcquired) times")
            
                switch self.numberOfTimesAcquired{
                case 1..<5:
                    collectibleManager.increaseCarryingCapacity(by: 10)
                    break
                case 5..<10:
                    collectibleManager.increaseCarryingCapacity(by: 20)
                    break
                case 10..<15:
                    collectibleManager.increaseCarryingCapacity(by: 30)
                    break
                case 15..<20:
                    collectibleManager.increaseCarryingCapacity(by: 40)
                    break
                case 20..<25:
                    collectibleManager.increaseCarryingCapacity(by: 50)
                    break
                case 25...30:
                    break
                default:
                    collectibleManager.increaseCarryingCapacity(by: 60)
                    break
                }
                
            
            print("Player carrying capacity has increased to \(self.collectibleManager.carryingCapacity) times")

        }
    }
    
    
   
    
    func applyMovementImpulse(withMagnitudeOf forceUnits: CGFloat){
        
        let dx = self.appliedUnitVector.dx*forceUnits
        let dy = self.appliedUnitVector.dy*forceUnits
        
        self.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }
    
    
    public func addCollectibleItem(newCollectible: Collectible, completionHandler:(() -> Void)? = nil){
        
        collectibleManager.addCollectibleItem(newCollectible: newCollectible, andWithQuantityOf: 1)
    
        if completionHandler != nil{
            completionHandler!()
        }
        
    }
    
    public func showCollectibleManagerDescription(){
        
        collectibleManager.showDescriptionForCollectibleManager()
        
    }
    
    public func increaseHealth(byHealthUnits healthUnits: Int){
        print("Increasing player health...")

        if(self.health + healthUnits > 15){
            self.health = 15
        } else {
            self.health += healthUnits
        }
        
        HUDManager.sharedManager.updateHealthCount(withUnits: self.health)
    }
    
    public func takeDamage(){
    
        
        if(isInvulnerable){
            return
        }
        
        if(isTemporarilyInvulnerable) {
            return
            
        } else
        {
            self.isTemporarilyInvulnerable = true

        }
        

        run(SKAction.sequence([
            SKAction.run {
                print("Player has taken damage...")
                self.health -= 1
                HUDManager.sharedManager.updateHealthCount(withUnits: self.health)
                
            },
            SKAction.wait(forDuration: 0.20)
            ]), completion: {
            
            self.isTemporarilyInvulnerable = false
        })
        
    }
    
    public func increaseBullets(byBullets bullets: Int){
        print("Bullets have increased by \(bullets)")
        
        if(self.numberOfBullets + bullets > 30){
            self.numberOfBullets = 30
        } else {
            self.numberOfBullets += bullets
        }
        HUDManager.sharedManager.updateBulletCount(withUnits: self.numberOfBullets)

    }
    
    public func fireBullet(){
        
        if(self.numberOfBullets <= 0) { return }
        
        super.fireBullet(withPrefireHandler: {}, andWithPostfireHandler: {})
        
        self.numberOfBulletsFired += 1
        self.numberOfBullets -= 1
        HUDManager.sharedManager.updateBulletCount(withUnits: self.numberOfBullets)
        
        
        print("Gun fired!")
        
    }
    
    public func getNumberOfBulletsFired() -> Int{
        return self.numberOfBulletsFired
    }
    
    
    public func playSoundForCollectibleContact(){
        run(self.playCollectItemSound)
    }
    
    public func hasItem(ofType collectibleType: CollectibleType) -> Bool{
        
        let collectible = Collectible(withCollectibleType: collectibleType)
        
        return self.collectibleManager.hasItem(collectible: collectible)
        
    }
    
    
    
    @objc func activateSpecialWeapon(notification: Notification?){
        
        print("Activating special weapon for player...")
        
        if let userInfo = notification?.userInfo, let rawValue = userInfo["collectibleRawValue"] as? Int,let isActive = userInfo["isActive"] as? Bool{
            

            let collectibleType = CollectibleType(rawValue: rawValue)!
            
            print("Activated weapon is \(collectibleType.getCollectibleName()) and active status has been changed to \(isActive ? "acitve":"inactive")")

            switch collectibleType{
                case .FlaskGreen:
                    break
                case .Bomb:
                    break
                case .PowerDrill:
                    break
                case .Cellphone1:
                    break
                case .Syringe:
                    isInvulnerable = isActive ? true : false
                    break
                case .BeakerRed:
                    if(!isActive){
                        collectibleManager.removeCollectible(ofType: .BeakerRed)
                    }
                    break
                default:
                    return
            }
        }
        
        
    }
    

    
    //MARK: ********** Initializers for Player Character
    
    convenience init(playerProfile: PlayerProfile) {
        
        let rawValue = Int(playerProfile.playerType)
        let playerType = PlayerType(withIntegerValue: rawValue)
        
        self.init(playerType: playerType)
        self.playerProfile = playerProfile
        equipPlayerWithSpecialWeapon()
        
    }
    
    convenience init(playerType: PlayerType, scale: CGFloat){
        self.init(playerType: playerType)
        
        self.xScale *= scale
        self.yScale *= scale
        
        
    }
    
    convenience init(playerType: PlayerType,startingHealth: Int = 15, numberOfBullets: Int = 30){
        
        let playerTexture = playerType.getTexture(textureType: .gun)
        
        self.init(texture: playerTexture, color: .clear, size: playerTexture.size())
        
        self.numberOfBullets = numberOfBullets
        self.health = startingHealth
        
        
    }
    
    convenience init(playerProfile: PlayerProfile, playerStateSnapshot: PlayerStateSnapShot) {
        
        let numberOfBullets = playerStateSnapshot.numberOfBullets
        let startingHealth = playerStateSnapshot.healthLevel
        let playerType = playerStateSnapshot.playerType
        
        self.init(playerType: playerType, startingHealth: startingHealth, numberOfBullets: numberOfBullets)
        
        self.playerProfile = playerProfile
        configurePlayerState(withPlayerStateSnapshot: playerStateSnapshot)
        equipPlayerWithSpecialWeapon()
        
    }
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let defaultPlayerType = PlayerType(rawValue: "manBlue")!
        
        self.playerType = defaultPlayerType
        self.compassDirection = .east
        
        let texture = texture ?? defaultPlayerType.getTexture(textureType: .gun)
        
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.Player.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.Player.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.Player.contactMask
        self.physicsBody?.fieldBitMask = ColliderType.RepulsionField.categoryMask
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 1.00
        self.physicsBody?.angularDamping = 0.00
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(activateSpecialWeapon(notification:)), name: Notification.Name.GetDidActivateCollectibleNotificationName(), object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


