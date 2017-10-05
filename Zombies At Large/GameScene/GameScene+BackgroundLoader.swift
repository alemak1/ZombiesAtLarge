//
//  GameScene+BackgroundLoader.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene{
    
    
    func loadBackground(){
        
        addGrassBackgrounds()
        addBlackCorridors()
        addWoodfloors()
        
    }
    
    func loadBgLevel1(){
        
        addGrassBackgrounds()
        addBlackCorridors()
        addWoodfloors()
        
    }
    
    func loadBgLevel2(){
        
        guard let stoneBackground = SKScene(fileNamed: "backgrounds2")?.childNode(withName: "StoneBackgrounds") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
       
        
        addBulletsTo(tileMapNode: stoneBackground)
        addZombiesTo(someTileMapNode: stoneBackground)
        addRiceBowlsTo(someTileMapNode: stoneBackground)
        addRedEnvelopeTo(someTileMapNode: stoneBackground)
        addCollectiblesTo(someTileMapNode: stoneBackground)
        
        stoneBackground.move(toParent: backgroundNode)
        
        guard let blackCorridor = SKScene(fileNamed: "backgrounds2")?.childNode(withName: "BlackCorridors") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
        addObstaclePhysicsBodiesTo(tileMapNode: blackCorridor)
        
        blackCorridor.move(toParent: backgroundNode)
        
        guard let woodFloor = SKScene(fileNamed: "backgrounds2")?.childNode(withName: "WoodFloors") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
        addBulletsTo(tileMapNode: woodFloor)
        addZombiesTo(someTileMapNode: woodFloor)
        addRiceBowlsTo(someTileMapNode: woodFloor)
        addCollectiblesTo(someTileMapNode: woodFloor)
        addRescueCharacterTo(someTileMapNode: woodFloor)
        addSafetyZonesTo(tileMapNode: woodFloor)
        
        woodFloor.move(toParent: backgroundNode)
    
    }
    
    
    
    func addSafetyZone(fromNode backgroundNode: SKNode){
        
        guard let safetyZone = backgroundNode.childNode(withName: "SafetyZone") as? SKSpriteNode else {
            fatalError("Error: the safety zone failed to load or could not be found")
        }
        
        self.safetyZone = safetyZone
        
        if self.safetyZone != nil{
            self.safetyZone!.name = "SafetyZone"
            self.safetyZone!.move(toParent: worldNode)

        }
    }

    
    
    
    func addGrassBackgrounds(){
        
        guard let grass = SKScene(fileNamed: self.currentGameLevel.getSKSceneFilename())?.childNode(withName: "grass") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
        let grassRows = grass.numberOfRows
        let grassCols = grass.numberOfColumns
        
        for row in 1...grassRows{
            for col in 1...grassCols{
                
                
                loadTileWithBasicGameElements(tileMapNode: grass, row: row, col: col)
                
                
            }
            
            DispatchQueue.main.async {
                 NotificationCenter.default.post(name: Notification.Name(rawValue: Notification.Name.didUpdateGameLoadingProgressNotification), object: nil, userInfo: ["progressAmount":Float(0.05)])
            }
            
           

        }
        
        grassTileMap = grass
        
        grassTileMap.position = CGPoint(x: 0.00, y: 0.00)
        
        grassTileMap.move(toParent: backgroundNode)
        
        
    }
    
    func addBlackCorridors(){
        
        guard let blackCorridors = SKScene(fileNamed: self.currentGameLevel.getSKSceneFilename())?.childNode(withName: "blackcorridors") as? SKTileMapNode else {
            
            fatalError("Error: tile backgrounds failed to load")
        }
        
        for row in 0...blackCorridors.numberOfRows{
            for col in 0...blackCorridors.numberOfColumns{
                
                addObstaclePhysicsBodies(tileMapNode: blackCorridors, row: row, column: col)
            }
            
          
        }
        
        
        blackCorridorTileMap = blackCorridors
        
        blackCorridorTileMap.position = CGPoint(x: 0.00, y: 0.00)
        
        blackCorridorTileMap.move(toParent: backgroundNode)
        
    }
    
    func addWoodfloors(){
        
        guard let woodFloors = SKScene(fileNamed: self.currentGameLevel.getSKSceneFilename())?.childNode(withName: "woodfloors") as? SKTileMapNode else {
            
            print("Warning: No woodfloors for the current game scene")
            return
        }
        
        let woodRows = woodFloors.numberOfRows
        let woodCols = woodFloors.numberOfColumns
        
        woodFloors.position = CGPoint(x: 0.00, y: 0.00)
        
        for row in 1...woodRows{
            for col in 1...woodCols{
    
                loadTileWithBasicGameElements(tileMapNode: woodFloors, row: row, col: col)
            }
            
         

        }
        
        woodFloorTileMap = woodFloors
        
        woodFloorTileMap.move(toParent: backgroundNode)
    }
    
    
    func loadTileWithBasicGameElements(tileMapNode: SKTileMapNode, row: Int, col: Int){
        if(loadableGameSceneSnapshot == nil){
            
            addSafetyZone(tileMapNode: tileMapNode, row: row, column: col)
            addRandomCollectible(tileMapNode: tileMapNode, row: row, column: col)
            addRequiredCollectible(tileMapNode: tileMapNode, row: row, column: col)
            addSafetyZone(tileMapNode: tileMapNode, row: row, column: col)
            addBullet(tileMapNode: tileMapNode, row: row, column: col)
            addZombie(tileMapNode: tileMapNode, row: row, column: col)
            addMustKillZombie(tileMapNode: tileMapNode, row: row, column: col)
            addRiceBowl(tileMapNode: tileMapNode, row: row, column: col)
            addRescueCharacter(tileMapNode: tileMapNode, row: row, column: col)
        }
    }
    
    func addRandomCollectible(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
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
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasZombie = tileDef?.userData?["hasZombie"] as? Bool
        
        
        if(hasZombie ?? false){
            let zombiePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            let newZombie = Zombie(zombieType: .zombie1)
            newZombie.position = zombiePos
            newZombie.move(toParent: worldNode)
            zombieManager.addLatentZombie(zombie: newZombie)
            
        }
    }
    
    
    func addMustKillZombie(tileMapNode: SKTileMapNode, row: Int, column: Int){
     
        guard let mustKillZombieTracker = self.mustKillZombieTrackerDelegate else {
            print("Error: no must kill zombie tracker available")
            return
        }
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasMustKillZombie = tileDef?.userData?["hasMustKillZombie"] as? Bool
        
        if(hasMustKillZombie ?? false){
            
            
            let mustKillZombiePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            var mustKillZombie: Zombie?
            
            if(mustKillZombieTracker.getNumberOfUnkilledZombies() >= self.currentGameLevel.getNumberOfMustKillZombies()){
                
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
                        mustKillZombie = Zombie(zombieType: .zombie1, scale: 1.00, startingHealth: 6)
                        break
                }
                
                    print("Adding must kill zombie to games scene")
                    mustKillZombie!.position = mustKillZombiePos
                    mustKillZombie!.move(toParent: worldNode)
                    mustKillZombie!.name = "MustKillZombie\(mustKillZombieTracker.getNumberOfUnkilledZombies())"
                    zombieManager.addDynamicZombie(zombie: mustKillZombie as! Updateable)
                    mustKillZombieTracker.addMustKillZombie(zombie: mustKillZombie!)
                    print("The number of mustKillZombies is \(mustKillZombieTracker.getNumberOfUnkilledZombies())")
                
            
            }
        }
    }
    
    
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
    
    
    func addRiceBowl(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
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
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasRedEnvelope = tileDef?.userData?["hasRedEnvelope"] as? Bool
        
        if(hasRedEnvelope ?? false){
            
            let redEnvelopePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            let redEnvelope = RedEnvelope(monetaryValue: nil)
            redEnvelope.move(toParent: worldNode)
            redEnvelope.position = redEnvelopePos
            
            
        }
    }
    
    func addRequiredCollectible(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        guard let requiredCollectibleTracker = self.requiredCollectiblesTrackerDelegate else {
            
            fatalError("Error: found nil whil unwrapping the required collectible tracker")
            
        }
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasRequiredCollectible = tileDef?.userData?["hasRequiredCollectible"] as? Bool
        
        if(hasRequiredCollectible ?? false){
            print("Adding required collectible to the tile map....")
            
            let requiredCollectiblePos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            
            if(requiredCollectibleTracker.numberOfRequiredCollectibles >= self.currentGameLevel.getNumberOfRequiredCollectibles()){
                
                return
                
            } else if let requiredCollectibleType = self.currentGameLevel.getRequiredCollectibleType() {
                
                let collectibleSprite = requiredCollectibleType.getCollectibleSprite()
                
                collectibleSprite.move(toParent: worldNode)
                collectibleSprite.name = "RequiredCollectible"
                collectibleSprite.position = requiredCollectiblePos
                collectibleSprite.zPosition = 30
                
                requiredCollectibleTracker.addRequiredCollectible(requiredCollectible: collectibleSprite)
                
                
            }
            
            
        }
        
    }
    
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
    
    func addObstaclePhysicsBodies(tileMapNode: SKTileMapNode, row: Int, column: Int){
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
            
           // tileMapNode.addChild(pbNode)
            
            
            
        }
        
    }
    
    
    
    func addRescueCharacter(tileMapNode: SKTileMapNode, row: Int, column: Int){
        
        
        guard let unrescuedCharactersTracker = self.unrescuedCharactersTrackerDelegate else {
            fatalError("Error: found nil while unwrapping the unrescued characters delegate")
        }
        
        let tileDef = tileMapNode.tileDefinition(atColumn: column, row: row)
        
        let hasRescueCharacter = tileDef?.userData?["hasRescueCharacter"] as? Bool
        
        if(hasRescueCharacter ?? false){
            print("Adding rescue character to the tile map....")
            
            let rescueCharPos = tileMapNode.centerOfTile(atColumn: column, row: row)
            
            print("Adding rescue character to the tile map at pos row: \(row), col: \(column)....")
            
            
            if(unrescuedCharactersTracker.numberOfUnrescuedCharacters >= self.currentGameLevel.getNumberOfUnrescuedCharacter()){
                
                return
                
            } else {
                
                let rescueCharacterType = self.currentGameLevel.getRescueCharacterType()
                
                let rescueCharacter = RescueCharacter(withPlayer: self.player, nonPlayerCharacterType: rescueCharacterType)
                
                rescueCharacter.move(toParent: worldNode)
                rescueCharacter.name = "RescueCharacter"
                rescueCharacter.position = rescueCharPos
                unrescuedCharactersTracker.addUnrescuedCharacters(rescueCharacter: rescueCharacter)

             
                
            }
            
            
        }
    }
    

    
    func addRequiredCollectibleTo(someTileMapNode tileMapNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapNode, withHandler: addRequiredCollectible)
    }
    
    func addRescueCharacterTo(someTileMapNode tileMapNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapNode, withHandler: addRescueCharacter)
    }
    
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
    
    func addSafetyZonesTo(tileMapNode tileMapeNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapeNode, withHandler: addSafetyZone)
    }
    
    func addMustKillZombiesTo(tileMapNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapNode, withHandler: addMustKillZombie)
    }
    
    func addObstaclePhysicsBodiesTo(tileMapNode tileMapeNode: SKTileMapNode){
        self.traverseTileMap(tileMap: tileMapeNode, withHandler: addObstaclePhysicsBodies)
    }
    
    func traverseTileMap(tileMap: SKTileMapNode, withHandler handler: (SKTileMapNode,Int,Int) -> Void){
        
        let rows = tileMap.numberOfRows
        let columns = tileMap.numberOfColumns
        
        for row in 1...rows{
            for col in 1...columns{
                    handler(tileMap,row,col)
            }
        }
    }
    
}


