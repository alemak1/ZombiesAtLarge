//
//  NonplayerCharacter.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/13/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import Vision
import CoreML
import UIKit

class NonplayerCharacter: SKSpriteNode{
    
    var nonPlayerCharacterType: NonplayerCharacterType!
    
    var isMissionCompleted = false
    
    
    enum CoreMLModel: Int{
        case Resnet50 = 0
        case GoogLeNetPlaces
        
    }
    
    var activeModel: NSObject?
    
    lazy var targetPictureString: String? = {
        
        return RandomObjectStringGenerator.GetRandomString()
        
    }()
    
    func setActiveModelTo(coreMLModel: CoreMLModel){
        
        self.activeModel = nil
        
        switch coreMLModel {
        case .Resnet50:
            self.activeModel = try? VNCoreMLModel(for: Resnet50().model)
            break
        case .GoogLeNetPlaces:
            self.activeModel = try? VNCoreMLModel(for: GoogLeNetPlaces().model)
            break
        }
    }
    
    
    
    /** Upon contact with the player, generate a random target picture string and then generate the mission prompt, which gives the user the option of taking a picture or declining the mission **/
    
    func setTargetPictureString(){
        
        let _ = self.targetPictureString
        
    }
    
    func generateMissionPrompt() -> SKSpriteNode{
        
        return UIPanelGenerator.GetDialoguePrompt(forAvatar: self.nonPlayerCharacterType.getAvatarType(), withName: self.name!, andWithText1: "Can you help me", andWithText2: "find a picture", andWithText3: "of a \(self.targetPictureString!)", andWithText4: "I want to see it.")!
    }
    
    /** If the player accepts the mission, then the player saves the image in an instanc variable in the player class and then posts a notification whose object is allows the NPC to accept the picture and perform any necessary analysis **/
    
    func checkModelGuess(modelGuess: String){
        
        if(targetPictureString != nil && targetPictureString!.contains(modelGuess)){
            isMissionCompleted = true
        }
        
    }
    
    func acceptImageFromPlayerForAnalysis(_ image: CGImage){
        
        DispatchQueue.global(qos: .background).async {
            
            
            guard let activeModel = self.activeModel as? VNCoreMLModel else { return }
            
            let request = VNCoreMLRequest(model: activeModel, completionHandler: {(request, error) in
                
                guard let results = request.results as? [VNClassificationObservation] else { fatalError("error")}
                
                
                /** There must be 90% or above confidence in the guess in order for the NPC to accept the picture **/
                
                if let mostProbableClassification = results.first(where: { classification in
                    
                    return (classification.confidence > 0.90)
                    
                }){
                    
                    /** Check that the identifier (string result of the CoreML model output) matches the arget picture string for this character **/
                    let mostProbableIdentifier = mostProbableClassification.identifier
                    
                    self.checkModelGuess(modelGuess: mostProbableIdentifier)

                } else {
                    
                    print("Mission failed; unable to get good results from picture")
                }
            
    
                
                DispatchQueue.main.async {
                    
                    if(self.isMissionCompleted){
                        //Tell user good job, post any necessary notifications  or perform additional processing
                    } else {
                        //Tell user to try again
                    }
                    
                }
            })
        }
    }
    
    
    var compassDirection: CompassDirection!{
        didSet{
            
            guard oldValue != compassDirection else { return }
            
            let rotation = ((compassDirection.zRotation - oldValue.zRotation) <= CGFloat.pi) && (compassDirection.zRotation > oldValue.zRotation)  ? (compassDirection.zRotation - oldValue.zRotation) : -(oldValue.zRotation - compassDirection.zRotation)
            
            
            run(SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.10))
            
            
        }
    }
    
    
   
    convenience init(nonPlayerCharacterType: NonplayerCharacterType, andName name: String) {
        
        
        guard let texture = nonPlayerCharacterType.getTexture() else {
            fatalError("Error: Failed to located the texture for the nonPlayerCharacterType")
        }
        
        self.init(texture: texture, color: .clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.categoryBitMask = ColliderType.NonPlayerCharacter.categoryMask
        self.physicsBody?.collisionBitMask = ColliderType.NonPlayerCharacter.collisionMask
        self.physicsBody?.contactTestBitMask = ColliderType.NonPlayerCharacter.contactMask
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 1.00
        self.physicsBody?.angularDamping = 0.00
        
        self.nonPlayerCharacterType = nonPlayerCharacterType
        self.compassDirection = .east
        
        self.name = name
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
 
    
   
}
