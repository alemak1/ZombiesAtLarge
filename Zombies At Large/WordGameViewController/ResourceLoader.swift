//
//  ResourceLoader.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

/** The ResourceLoader preloads the main layers of the backgroundNode as well populates the worldNode withe enemies and collectibles; the preloaded nodes are then assigned to their counterparts in the GameScene  **/

class ResourceLoader{
    
    static let GrassTilemapNodeName = "GrassTileMapNode"
    static let CorridorTilemapNodeName = "CorridorTileMapNode"
    static let FloorTilemapNodeName = "FloorTileMapNode"


    typealias PreloadedNodeSet = (SKNode?,SKNode?,SKNode?)
    
    static let sharedLoader = ResourceLoader()
    

    private init(){
        self.progressUnits = 0
        
    }
    

    var backgroundNode: SKNode!
    var worldNode: SKNode!
    var overlayNode: SKNode!
    
    
    var currentGameLevel: WordGameLevel = .Level1
    
    var zombieManager: ZombieManager?
    var safetyZone: SafetyZone?
    
    
    /** Progress Units **/
    
    var percentProgress: Float{
        return Float(progressUnits)/Float(totalProgressUnits)
    }
    
    var totalProgressUnits: Int{
        
        return 100
        
        /**
        return (grassTileMap.numberOfRows*grassTileMap.numberOfColumns*grassHandlers.count) + (corridorTileMap.numberOfColumns*corridorTileMap.numberOfRows*corridorHandlers.count) + (floorTileMap.numberOfColumns*floorTileMap.numberOfRows*woodFloorHandlers.count)
         **/
    }
    
    var progressUnits: Int{
    
        didSet{
            NotificationCenter.default.post(name: Notification.Name.GetDidUpdateGameLoadingProgressNotification(), object: nil, userInfo: [
                "progress":self.percentProgress
                ])
        }
    }
    
    /** Get the cached scene resources for initializing an instance of the WordGameScene **/
    
    func getPreloadedNodes() -> PreloadedNodeSet{
        
        print("Getting preloaded nodes...")
        
        if(self.backgroundNode == nil || self.worldNode == nil || self.overlayNode == nil){
                print("Preloaded nodes are still nil...")
        }
        
        return (self.backgroundNode,self.worldNode,self.overlayNode)
    }
    
    
    func setCurrentGameLevel(to currentGameLevel: WordGameLevel){
        self.currentGameLevel = currentGameLevel
    }
    
    /** Whe resources for the current level are finished loading and the WordGameScene instance for the current level has finishe initializing with the preloaded node layers, the resource loader clears its cached resources and beings loading cached resources for the next level **/
    
    func prepareLoadingResources(forNextLevel level: WordGameLevel){
        
        backgroundNode = nil
        worldNode = nil
        overlayNode = nil
        
        let nextLevel = self.currentGameLevel.getNextLevel()
        loadBackground(forWordGameLevel: nextLevel, completion: nil)
    }
    
    
    
    func loadResourcesForWordGameLevel(wordGameLevel: WordGameLevel){
        
        loadBackground(forWordGameLevel: wordGameLevel, completion: {
            
            hasFinishedLoadingResources in
            
            if(!hasFinishedLoadingResources){
                
                self.loadResourcesForWordGameLevel(wordGameLevel: wordGameLevel)
                
            } else {
                
                print("Resources have finished loading for word game level \(wordGameLevel.rawValue)")
                
                let userInfo = [
                    "level": wordGameLevel.rawValue
                ]
                
                DispatchQueue.main.async {
                       NotificationCenter.default.post(name: Notification.Name.GetDidFinishedLoadingSceneNotification(), object: nil, userInfo: userInfo)
                }
                
             
            }
            
        })
    }

    
    func loadBackground(forWordGameLevel level: WordGameLevel, completion: ((Bool)-> Void)?){
        
        /** If the node layers have already been preloaded, then the completion handler gets called immediately, with a boolean flag set to true for argument passed into the completion handler **/
        
         let nodesAreLoaded = self.backgroundNode != nil && self.overlayNode != nil && self.worldNode != nil
        
        if(nodesAreLoaded) && completion != nil{
            completion!(true)
            return
        }
        
        print("Loading generic background elements....")
        
        loadGenericBackgroundB()
        
        
        print("Loading level-specific custom background elements....")

        /** Perform custom level loading on a per-level basis, looping through children of an SKNode container for special objects and enemies pertaining to that level, or adding additional handlers which check the userInfo dictionary for a tileMap node **/
        switch level{
        case .Level1:
            break
        case .Level2:
            break
        case .Level3:
            break
        case .Level4:
            break
        case .Level5:
            break
        default:
            break
        }
        
        if let completion = completion{
            
            completion(true)
        }
        
    }
    
    func loadBgLevel1(){
        
        
        addGrassBackgrounds()
        addBlackCorridors()
        addWoodfloors()
        
    }
    
    
    func loadBgLevel2(){
        
    }
    
    func loadBgLevel3(){
        
    }
    
    func loadBgLevel4(){
       
        
        
    }
    
    func loadBgLevel5(){
        
    }
    
    
    func addSafetyZone(fromNode backgroundNode: SKNode){
        
        print("Adding safety zone ...")

        guard let safetyZone = backgroundNode.childNode(withName: "SafetyZone") as? SKSpriteNode else {
            fatalError("Error: the safety zone failed to load or could not be found")
        }
        
        
        safetyZone.name = "SafetyZone"
        safetyZone.move(toParent: worldNode)
            
        
    }
    
    

   
    
    
    func addRandomCollectible(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        print("Adding random collectibles ...")

        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasCollectible = tileDef?.userData?["hasCollectible"] as? Bool
        
        
        if(hasCollectible ?? false){
            let collectiblePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            let randomCollectibleType = CollectibleType.getRandomCollectibleType()
            
            let randomCollectibleSprite = CollectibleSprite(collectibleType: randomCollectibleType, scale: 0.50)
            
            randomCollectibleSprite.position = collectiblePos
            randomCollectibleSprite.zPosition = 10
            randomCollectibleSprite.move(toParent: worldNode)
            
            
        }
    }
    
    
    
    
    func addBullet(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        print("Adding bullets ...")

        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasBullet = tileDef?.userData?["hasBullet"] as? Bool
        
        if(hasBullet ?? false){
            
            let bulletPos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            let bullet = Bullet(numberOfBullets: 1)
            bullet.move(toParent: worldNode)
            bullet.position = bulletPos
            
            
        }
    }
    
    func addZombie(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        print("Adding zombies ...")

        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasZombie = tileDef?.userData?["hasZombie"] as? Bool
        
        
        if(hasZombie ?? false){
            let zombiePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            let newZombie = Zombie(zombieType: .zombie1)
            newZombie.position = zombiePos
            newZombie.move(toParent: worldNode)
            
        }
    }
    
    
    /**
    
    func addMustKillZombie(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasMustKillZombie = tileDef?.userData?["hasMustKillZombie"] as? Bool
        
        if(hasMustKillZombie ?? false){
            
            
            let mustKillZombiePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            var mustKillZombie: Zombie?
            
            if(self.mustKillZombies.count >= self.currentGameLevel.getNumberOfMustKillZombies()){
                
                return
                
            } else {
                
                let mustKillZombieType = self.currentGameLevel.getMustKillZombieType()
                
                switch mustKillZombieType{
                case is GiantZombie.Type:
                    mustKillZombie = GiantZombie(zombieType: .zombie1, scale: 2.00, startingHealth: 6)
                    break
                case is CamouflageZombie.Type:
                    break
                case is MiniZombie.Type:
                    break
                default:
                    break
                }
                
                if let mustKillZombie = mustKillZombie{
                    print("Adding must kill zombie to games scene")
                    mustKillZombie.position = mustKillZombiePos
                    mustKillZombie.move(toParent: worldNode)
                    mustKillZombie.name = "MustKillZombie\(self.mustKillZombies.count)"
                    zombieManager.addDynamicZombie(zombie: mustKillZombie as! Updateable)
                    mustKillZombies.insert(mustKillZombie)
                    print("The number of mustKillZombies is \(self.mustKillZombies.count)")
                }
            }
            
            
        }
    }
    
    **/
    
    
    /**
    func addSpecialZombie(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasSpecialZombie = tileDef?.userData?["hasSpecialZombie"] as? Bool
        let specialZombieType = tileDef?.userData?["specialZombieType"] as? Int
        let zombieTypeString = tileDef?.userData?["zombieType"] as? String
        
        if(hasSpecialZombie ?? false), let specialZombieType = specialZombieType,let zombieTypeString = zombieTypeString, let zombieType = ZombieType(rawValue: zombieTypeString){
            
            let zombiePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            let specialZombieType = SpecialZombieType(rawValue: specialZombieType)!
            
            switch specialZombieType{
            case .CZombie:
                let newZombie = CamouflageZombie()
                newZombie.position = zombiePos
                newZombie.move(toParent: worldNode)
                zombieManager.addDynamicZombie(zombie: newZombie)
                break
            case .GZombie:
                let newZombie = GiantZombie(zombieType: zombieType, scale: 1.00, startingHealth: 6)
                newZombie.position = zombiePos
                newZombie.move(toParent: worldNode)
                zombieManager.addDynamicZombie(zombie: newZombie)
                break
            case .MZombie:
                let newZombie = MiniZombie(zombieType: zombieType, scale: 1.00, startingHealth: 1)
                newZombie.position = zombiePos
                newZombie.move(toParent: worldNode)
                zombieManager.addDynamicZombie(zombie: newZombie)
                break
            }
            
            
            
        }
    }
    
    **/
    
    func addRiceBowl(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        print("Adding rice bowls ...")

        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasRiceBowl = tileDef?.userData?["hasRiceBowl"] as? Bool
        
        if(hasRiceBowl ?? false){
            
            let riceBowlPos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            let riceBowl = RiceBowl(healthValue: 2)
            riceBowl.move(toParent: worldNode)
            riceBowl.position = riceBowlPos
            
            
        }
    }
    
    func addRedEnvelope(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        print("Adding red envelopes ...")

        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasRedEnvelope = tileDef?.userData?["hasRedEnvelope"] as? Bool
        
        if(hasRedEnvelope ?? false){
            
            let redEnvelopePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            let redEnvelope = RedEnvelope(monetaryValue: nil)
            redEnvelope.move(toParent: worldNode)
            redEnvelope.position = redEnvelopePos
            
            
        }
    }
    
    
    /**
    func addRequiredCollectible(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasRequiredCollectible = tileDef?.userData?["hasRequiredCollectible"] as? Bool
        
        if(hasRequiredCollectible ?? false){
            print("Adding required collectible to the tile map....")
            
            let requiredCollectiblePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            
            if(self.requiredCollectibles.count >= self.currentGameLevel.getNumberOfRequiredCollectibles()){
                
                return
                
            } else if let requiredCollectibleType = self.currentGameLevel.getRequiredCollectibleType() {
                
                let collectibleSprite = requiredCollectibleType.getCollectibleSprite()
                
                collectibleSprite.move(toParent: worldNode)
                collectibleSprite.name = "RequiredCollectible"
                collectibleSprite.position = requiredCollectiblePos
                collectibleSprite.zPosition = 30
                requiredCollectibles.insert(collectibleSprite)
                
            }
            
            
        }
        
    }
     **/
    
    /**
    func addSafetyZone(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasSafetyZone = tileDef?.userData?["hasSafetyZone"] as? Bool
        
        if(hasSafetyZone ?? false){
            print("Adding safety zone to the tile map....")
            
            let safetyZonePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            print("Adding safety zone to the tile map at pos row: \(row), col: \(column)....")
            
            let safetyZone = SafetyZone(safetyZoneType: .Green, scale: 1.00)
            safetyZone.move(toParent: worldNode)
            safetyZone.position = safetyZonePos
            safetyZone.zPosition = 30
            
            /** Assumption: There can only be one safety zone per map **/
            if self.safetyZone == nil{
                self.safetyZone = safetyZone
            }
        }
        
    }
     **/
    
    func addObstaclePhysicsBodies(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        print("Adding physics bodies...")
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasPhysicsBody = tileDef?.userData?["hasPB"] as? Bool
        
        if(hasPhysicsBody ?? false){
            
            let tileHeight = tileMapNode.tileSize.height
            let tileWidth = tileMapNode.tileSize.width
            
            let tileCenter = tileMapNode.centerOfTile(atColumn: column, row: row)
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
            
            tileMapNode.addChild(pbNode)
            
            
            
        }
        
    }
    
    
    /**
    func addRescueCharacter(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasRescueCharacter = tileDef?.userData?["hasRescueCharacter"] as? Bool
        
        if(hasRescueCharacter ?? false){
            print("Adding rescue character to the tile map....")
            
            let rescueCharPos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            print("Adding rescue character to the tile map at pos row: \(row), col: \(column)....")
            
            
            if(self.unrescuedCharacters.count >= self.currentGameLevel.getNumberOfUnrescuedCharacter()){
                
                return
                
            } else {
                
                let rescueCharacterType = self.currentGameLevel.getRescueCharacterType()
                
                let rescueCharacter = RescueCharacter(withPlayer: self.player, nonPlayerCharacterType: rescueCharacterType)
                
                rescueCharacter.move(toParent: worldNode)
                rescueCharacter.name = "RescueCharacter"
                rescueCharacter.position = rescueCharPos
                unrescuedCharacters.insert(rescueCharacter)
                
            }
            
            
        }
    }
     
     
     
     func addRequiredCollectibleTo(someTileMapNode tileMapNode: SKTileMapNode){
     self.traverseTileMap(tileMap: tileMapNode, withHandler: addRequiredCollectible)
     }
     
     
     func addSafetyZonesTo(tileMapNode tileMapeNode: SKTileMapNode){
     self.traverseTileMap(tileMap: tileMapeNode, withHandler: addSafetyZone)
     }
     
     func addMustKillZombiesTo(tileMapNode: SKTileMapNode){
     self.traverseTileMap(tileMap: tileMapNode, withHandler: addMustKillZombie)
     }
     
     func addRescueCharacterTo(someTileMapNode tileMapNode: SKTileMapNode){
     self.traverseTileMap(tileMap: tileMapNode, withHandler: addRescueCharacter)
     }
     
     
    
    **/
    
    
  
    
   
    func addCollectiblesTo(someTileMapNode tileMapNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapNode, withHandler: addRandomCollectible)
    }
    
    func addZombiesTo(someTileMapNode tileMapNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapNode, withHandler: addZombie)
    }
    
    func addRedEnvelopeTo(someTileMapNode tileMapNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapNode, withHandler: addRedEnvelope)
    }
    
    func addRiceBowlsTo(someTileMapNode tileMapNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapNode, withHandler: addRiceBowl)
    }
    
    func addBulletsTo(tileMapNode tileMapeNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapeNode, withHandler: addBullet)
    }
  
    func addObstaclePhysicsBodiesTo(tileMapNode tileMapeNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapeNode, withHandler: addObstaclePhysicsBodies)
    }
    
    
    
    
    func loadGenericBackgroundA(){
        
        print("Loading grass  background tiles...")
        traverseTileMap(tileMap: grassTileMap, withHandlers: grassHandlers)
        
        print("Loading corridor  background tiles...")
        traverseTileMap(tileMap: corridorTileMap, withHandlers: corridorHandlers)
        
        print("Loading floor background tiles...")
        traverseTileMap(tileMap: floorTileMap, withHandlers: woodFloorHandlers)
    }
    
    func loadGenericBackgroundB(){
        
        print("Loading generic background tiles...")
        
        backgroundNode = SKNode()
        worldNode = SKNode()
        overlayNode = SKNode()
        
        /** Load Grass Tile Map **/
        print("Loading grass background tiles...")

        
        addZombiesTo(someTileMapNode: grassTileMap)
        addBulletsTo(tileMapNode: grassTileMap)
        addRedEnvelopeTo(someTileMapNode: grassTileMap)
        addRiceBowlsTo(someTileMapNode: grassTileMap)
   
        
        /** Load Corridors Tile Map **/
        print("Loading corridors background tiles...")

       // addObstaclePhysicsBodiesTo(tileMapNode: corridorTileMap)
        
        /** Load Floors Tile Map **/
        print("Loading floor background tiles...")
    
        addZombiesTo(someTileMapNode: floorTileMap)
        addCollectiblesTo(someTileMapNode: floorTileMap)
 
    
        grassTileMap.move(toParent: backgroundNode)
        corridorTileMap.move(toParent: backgroundNode)
        floorTileMap.move(toParent: backgroundNode)

       
        
    }
    
    
    lazy var grassTileMap: SKTileMapNode = {
        
        let sceneName = self.currentGameLevel.getSKSceneFilename()
        
        guard let tileMap = SKScene(fileNamed: sceneName)?.childNode(withName: ResourceLoader.GrassTilemapNodeName) as? SKTileMapNode else {
            fatalError("Error: failed to load the tileMap from the SKScene file")
        }
        
        print("GrassTileMap loaded...")

        return tileMap
    }()
    
    lazy var corridorTileMap: SKTileMapNode = {
        let sceneName = self.currentGameLevel.getSKSceneFilename()
        
        guard let tileMap = SKScene(fileNamed: sceneName)?.childNode(withName: ResourceLoader.CorridorTilemapNodeName) as? SKTileMapNode else {
            fatalError("Error: failed to load the tileMap from the SKScene file")
        }
        print("CorridorTilemap loaded...")

        return tileMap
    }()
    
    lazy var floorTileMap: SKTileMapNode = {
        
        let sceneName = self.currentGameLevel.getSKSceneFilename()
        
        guard let tileMap = SKScene(fileNamed: sceneName)?.childNode(withName: ResourceLoader.FloorTilemapNodeName) as? SKTileMapNode else {
            fatalError("Error: failed to load the tileMap from the SKScene file")
        }
        
        print("FloorTilemap loaded...")
        
        return tileMap
        
    }()
    
    typealias AddItemHandler = (SKTileMapNode,Int,Int) -> Void
    
    /** ProgressUnits are incremented every time the tileMap is completely traversed; the tileMap is traversed once i**/
    func traverseTileMap(tileMap: SKTileMapNode, withHandler handler: AddItemHandler){
        
        print("Traversing tile map \(tileMap.name!)")
        
        let rows = tileMap.numberOfRows
        let columns = tileMap.numberOfColumns
        
        for row in 1...rows{
            for col in 1...columns{
                
                handler(tileMap,row,col)
            }
        }
        
        self.progressUnits += 1
    }
    
    
    
    var grassHandlers: [AddItemHandler]{
        return [
            addBullet,
            addZombie,
            addRedEnvelope,
            addRiceBowl,
            addRandomCollectible
        ]
    }
    
    var corridorHandlers: [AddItemHandler]{
        return [
            addObstaclePhysicsBodies
        ]
    }
    
    var woodFloorHandlers: [AddItemHandler]{
        return [
            addBullet,
            addZombie,
            addRedEnvelope,
            addRiceBowl,
            addRandomCollectible
        ]
    }
    
    func traverseTileMap(tileMap: SKTileMapNode, withHandlers handlers: [AddItemHandler]){
    
        
        let rows = tileMap.numberOfRows
        let columns = tileMap.numberOfColumns
        
        for row in 1...rows{
            for col in 1...columns{
                for handler in handlers{
                    handler(tileMap,row,col)
                    self.progressUnits += 1
                }
            }
        }
        
    }
    

    
}


//MARK: ******** LEVEl1 LOADER HELPER FUNCTIONS

extension ResourceLoader{
    
    func addGrassBackgrounds(){
        
        guard let grass = SKScene(fileNamed: "backgrounds")?.childNode(withName: "grass") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
        let grassRows = grass.numberOfRows
        let grassCols = grass.numberOfColumns
        
        for row in 1...grassRows{
            for col in 1...grassCols{
                
                
                addRedEnvelope(tileMapNode: grass, row: row, column: col)
                addBullet(tileMapNode: grass, row: row, column: col)
                addRiceBowl(tileMapNode: grass, row: row, column: col)
                addZombie(tileMapNode: grass, row: row, column: col)
                
                
            }
            
            
        }
        
        
        grass.position = CGPoint(x: 0.00, y: 0.00)
        
        grass.move(toParent: backgroundNode)
        
        
    }
    
    func addBlackCorridors(){
        
        guard let blackCorridors = SKScene(fileNamed: "backgrounds")?.childNode(withName: "blackcorridors") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
        for row in 0...blackCorridors.numberOfRows{
            for col in 0...blackCorridors.numberOfColumns{
                
                addObstaclePhysicsBodies(tileMapNode: blackCorridors, row: row, column: col)
            }
            
            
        }
        
        
        
        blackCorridors.position = CGPoint(x: 0.00, y: 0.00)
        
        blackCorridors.move(toParent: backgroundNode)
        
    }
    
    func addWoodfloors(){
        
        guard let woodFloors = SKScene(fileNamed: "backgrounds")?.childNode(withName: "woodfloor") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        let woodRows = woodFloors.numberOfRows
        let woodCols = woodFloors.numberOfColumns
        
        woodFloors.position = CGPoint(x: 0.00, y: 0.00)
        
        for row in 1...woodRows{
            for col in 1...woodCols{
                addRandomCollectible(tileMapNode: woodFloors, row: row, column: col)
            }
            
            
            
        }
        
        
        woodFloors.move(toParent: backgroundNode)
    }
}
