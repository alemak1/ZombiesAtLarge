//
//  Airplane.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/9/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class KeyPoints{
    static let TopCenterX = CGPoint(x: 0.00, y: -UIScreen.main.bounds.size.height/2.00)
    static let BottomCenterX = CGPoint(x: 0.00, y: UIScreen.main.bounds.size.height/2.00)
    static let RightCenterY = CGPoint(x: UIScreen.main.bounds.size.width/2.00, y: 0.00)
    static let LeftCenterY = CGPoint(x: -UIScreen.main.bounds.size.width/2.00, y: 0.00)

}

//TODO: need to add functionality for self-removal, spawning bullets, detecting enemies, etc.

class Airplane: SKSpriteNode{
    
    enum AirplaneType{
        case Type1
        case Type2
        
        func getTexture() -> SKTexture{
            switch self {
            case .Type1:
                return SKTexture(imageNamed: "airplane1")
            case .Type2:
                return SKTexture(imageNamed: "airplane2")
            }
        }
        
        func getShadowTexture() -> SKTexture{
            switch self {
            case .Type1:
                return SKTexture(imageNamed: "airplaneShadow1")
            case .Type2:
                return SKTexture(imageNamed: "airplaneShadow2")
            }
        }
    }
    
    var maxFlightTime: TimeInterval = 10.00
    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    
    var appliedUnitVector: CGVector{
        
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
    
    
    lazy var randomDiagonalSpawnPoint: CGPoint? = {
        
        let possibleXPos = [UIScreen.main.bounds.size.width*1.50,-UIScreen.main.bounds.size.width*1.50]
        let possibleYPos = [UIScreen.main.bounds.size.height*1.50,-UIScreen.main.bounds.size.height*1.50]
        
        let randomIdxXPos = Int(arc4random_uniform(UInt32(possibleXPos.count)))
        let randomIdxYPos = Int(arc4random_uniform(UInt32(possibleYPos.count)))
        
        return CGPoint(x: possibleXPos[randomIdxXPos], y: possibleYPos[randomIdxYPos])


    }()
    
    lazy var randomFromLeftSpawnPoint: CGPoint? = {
        
        let randomSrc = GKRandomSource()
        let yDist = GKGaussianDistribution(randomSource: randomSrc, mean: 0.00, deviation: Float(UIScreen.main.bounds.size.height/2.00))
       
        return CGPoint(x: -UIScreen.main.bounds.size.width*1.50, y: CGFloat(yDist.nextUniform()))
        
    }()
    
    
    lazy var randomFromRightSpawnPoint: CGPoint? = {
        let randomSrc = GKRandomSource()
        let yDist = GKGaussianDistribution(randomSource: randomSrc, mean: 0.00, deviation: Float(UIScreen.main.bounds.size.height/2.00))
        
        return CGPoint(x: UIScreen.main.bounds.size.width*1.50, y: CGFloat(yDist.nextUniform()))
        
        
        
    }()
    
    lazy var randomFromTopSpawnPoint: CGPoint? = {
        let randomSrc = GKRandomSource()
        let xDist = GKGaussianDistribution(randomSource: randomSrc, mean: 0.00, deviation: Float(UIScreen.main.bounds.size.width/2.00))
        
        return CGPoint(x: CGFloat(xDist.nextUniform()), y: -(UIScreen.main.bounds.size.height/2.00)*1.50)
        
    }()
    
    lazy var randomFromBottomSpawnPoint: CGPoint? = {
        
        let randomSrc = GKRandomSource()
        let xDist = GKGaussianDistribution(randomSource: randomSrc, mean: 0.00, deviation: Float(UIScreen.main.bounds.size.width/2.00))
        
        return CGPoint(x: CGFloat(xDist.nextUniform()), y: (UIScreen.main.bounds.size.height/2.00)*1.50)
        
    }()
    
    
    lazy var randomSpawnPoint: CGPoint? = {
        
        let pointGenerators:[(() -> CGPoint)] = [
            //Random from Top Spawn Point
            {
            let randomSrc = GKRandomSource()
            let xDist = GKGaussianDistribution(randomSource: randomSrc, mean: 0.00, deviation: Float(UIScreen.main.bounds.size.width/2.00))
            
            return CGPoint(x: CGFloat(xDist.nextUniform()), y: (UIScreen.main.bounds.size.height/2.00)*1.50)
            
            },
            
            //Random from Bottom Spawn Point

            {
            let randomSrc = GKRandomSource()
            let xDist = GKGaussianDistribution(randomSource: randomSrc, mean: 0.00, deviation: Float(UIScreen.main.bounds.size.width/2.00))
            
            return CGPoint(x: CGFloat(xDist.nextUniform()), y: -(UIScreen.main.bounds.size.height/2.00)*1.50)
            
            },
        {   //Random from Right Spawn Point
            let randomSrc = GKRandomSource()
            let yDist = GKGaussianDistribution(randomSource: randomSrc, mean: 0.00, deviation: Float(UIScreen.main.bounds.size.height/2.00))
            
            return CGPoint(x: UIScreen.main.bounds.size.width*1.50, y: CGFloat(yDist.nextUniform()))
            
            
            
        },
        {   //Random from Left Spawn Point
            let randomSrc = GKRandomSource()
            let yDist = GKGaussianDistribution(randomSource: randomSrc, mean: 0.00, deviation: Float(UIScreen.main.bounds.size.height/2.00))
            
            return CGPoint(x: -UIScreen.main.bounds.size.width*1.50, y: CGFloat(yDist.nextUniform()))
            
            
            },
        
        {   //Random from Diagonal Spawn Point
            let possibleXPos = [UIScreen.main.bounds.size.width*1.50,-UIScreen.main.bounds.size.width*1.50]
            let possibleYPos = [UIScreen.main.bounds.size.height*1.50,-UIScreen.main.bounds.size.height*1.50]
            
            let randomIdxXPos = Int(arc4random_uniform(UInt32(possibleXPos.count)))
            let randomIdxYPos = Int(arc4random_uniform(UInt32(possibleYPos.count)))
            
            return CGPoint(x: possibleXPos[randomIdxXPos], y: possibleYPos[randomIdxYPos])

        }
    ]
        
        let randomIdx = Int(arc4random_uniform(UInt32(pointGenerators.count)))
        
        return pointGenerators[randomIdx]()
    }()
    
    
    var flightDirection: CompassDirection?{
        
        guard let randomSpawnPoint = self.randomSpawnPoint else { return nil }
        
        let leftBoundary = -UIScreen.main.bounds.size.width*0.50
        let rightBoundary = UIScreen.main.bounds.size.width*0.50
        let bottomBoundary = UIScreen.main.bounds.size.height*0.50
        let topBoundary = -UIScreen.main.bounds.size.height*0.50
        
        var possibleDirections = [CompassDirection]()
        
        switch (randomSpawnPoint.x,randomSpawnPoint.y) {
        case let (x,y) where x < leftBoundary && y > bottomBoundary:
            //origin below and to the left of screen
            possibleDirections = [CompassDirection.northEast,.eastByNorthEast,.northByNorthEast]
            break
        case let (x,y) where x < leftBoundary && y < topBoundary:
            //origin above and to the left of the screen
            possibleDirections = [CompassDirection.southEast,.eastBySouthEast,.southBySouthEast]
            break
        case let (x,y) where x > rightBoundary && y > bottomBoundary:
            //origin below and to the right of the screen
            possibleDirections = [CompassDirection.northWest,.northByNorthWest,.westByNorthWest]
            break
        case let (x,y) where x > rightBoundary && y < topBoundary:
            //origin above and to the right of the screen
            possibleDirections = [CompassDirection.southWest,.westBySouthWest,.southBySouthWest]
            break
        case let (x,y) where x < leftBoundary && (y > topBoundary && y < bottomBoundary):
            //origin from the left
            possibleDirections = [CompassDirection.east,.eastBySouthEast,.eastByNorthEast]
            break
        case let (x,y) where x > rightBoundary && (y > topBoundary && y < bottomBoundary):
            //origin from the right
            possibleDirections = [CompassDirection.west,.westBySouthWest,.westByNorthWest]
            break
        case  let (x,y) where (x < rightBoundary && x > leftBoundary) && y < bottomBoundary:
            //origin from the top
            possibleDirections = [CompassDirection.south,.southBySouthWest,.southBySouthEast]
            break
        case let (x,y) where (x < rightBoundary && x > leftBoundary) && y > topBoundary:
            //origin from the bottom
            possibleDirections = [CompassDirection.north,.northByNorthWest,.northByNorthEast]
            break
        default:
            break
        }
        
        let randomIdx = Int(arc4random_uniform(UInt32(possibleDirections.count)))
        return possibleDirections[randomIdx]
    }
    
    convenience init(airplaneType: AirplaneType) {
        let texture = airplaneType.getTexture()
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        let shadowTexure = airplaneType.getShadowTexture()
        let shadowNode = SKSpriteNode(texture: shadowTexure)
        shadowNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(shadowNode)
        shadowNode.position = CGPoint(x: 4.00, y: 4.00)
    }
    
    
    func setRandomSpawnPointAndCompassDirection(){

        let _ = self.randomSpawnPoint
        
        let _ = self.flightDirection
        
        self.compassDirection = self.flightDirection!
    
        
    }
    
    func getRandomSpawnPoint() -> CGPoint{
        
        guard let randomSpawnPoint = self.randomSpawnPoint else {
            fatalError("Error: make sure to set the random spawn point and compass direction before attempting to call the function getRandomSpawnPoint()")
        }
        
        return randomSpawnPoint
        
    }
    
    func applyForce(of forceUnits: CGFloat){
        
        let appliedForce = CGVector(dx: forceUnits*appliedUnitVector.dx, dy: forceUnits*appliedUnitVector.dy)
        self.physicsBody?.applyForce(appliedForce)
    }
    
    func applyImpulse(of forceUnits: CGFloat){
        
        let appliedForce = CGVector(dx: forceUnits*appliedUnitVector.dx, dy: forceUnits*appliedUnitVector.dy)
        
        self.physicsBody?.applyImpulse(appliedForce)
    }
    
    
    func update(with currentTime: TimeInterval){
        
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.compassDirection = .east
        super.init(texture: texture, color: color, size: size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.compassDirection = .east
        super.init(coder: aDecoder)
    }
    
}
