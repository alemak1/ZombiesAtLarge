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

//TODO: Make sure the nonplayer character has a reference to the prompt that it generates so that it can dynamicallyc change the context in response to playeyr actions.... No need to dismiss the prompt, just let the player use the cancel button

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
    
    func addMissionPrompt(toNode node: SKNode){
        
        let missionPromptNode = generateMissionPrompt()
        
        missionPromptNode.move(toParent: node)
    }
    
    func generateMissionPrompt() -> SKSpriteNode{
        
        print("The target picture string is \(self.targetPictureString!)")
        print("The character name is \(self.name!)")
        
        return UIPanelGenerator.GetDialoguePrompt(forAvatar: self.nonPlayerCharacterType.getAvatarType(), withName: self.name!, andWithText1: "Can you help me", andWithText2: "find a picture", andWithText3: "of a \(self.targetPictureString!)", andWithText4: "I want to see it.")!
    }
    
    /** If the player accepts the mission, then the player saves the image in an instanc variable in the player class and then posts a notification whose object is allows the NPC to accept the picture and perform any necessary analysis **/
    
    func checkModelGuess(modelGuess: String){
        
        print("Checking the classification identifier with the target string......")

        if(targetPictureString != nil && targetPictureString! == modelGuess){
            isMissionCompleted = true
        }
        
    }
    
    func acceptImageFromPlayerForAnalysis(_ image: CGImage){
        
        print("Processing player image...")

        DispatchQueue.global(qos: .userInitiated).async {
            
            print("Processing player image inside global queue...")

            
            guard let activeModel = self.activeModel as? VNCoreMLModel else { return }
            
            print("Active model \(activeModel.description) obtaine...")

            print("Making CoreML Request...")

            let request = VNCoreMLRequest(model: activeModel, completionHandler: {(request, error) in
                
                if(error != nil){
                    print("Error: please try making another request")
                    return
                }
                
                guard let results = request.results as? [VNClassificationObservation] else { fatalError("error")}
                

                /** There must be 90% or above confidence in the guess in order for the NPC to accept the picture **/
                
                if let mostProbableClassification = results.first(where: {
                    
                    print("Getting most probably classification for picked image......")
                    print("Identifier: \($0.identifier) with confidence of \($0.confidence)")
                    
                    return ($0.confidence > 0.50)
                    
                }){
                    
                    /** Check that the identifier (string result of the CoreML model output) matches the arget picture string for this character **/
                    let mostProbableIdentifier = mostProbableClassification.identifier
                    
                    print("Checking the player's guess...")

                    self.checkModelGuess(modelGuess: mostProbableIdentifier)

                } else {
                    
                    if let maxConfidenceClassification = results.sorted(by: {$0.confidence < $1.confidence}).first{
                        
                        
                        print("If you ask me, it looks like a .... \(maxConfidenceClassification.identifier)")
                        print("I'm about .... \(maxConfidenceClassification.confidence)")
                        
                    }
                    
                    
                    print("Mission failed; unable to get good results from picture")
                    
        

                }
            
    
                
                DispatchQueue.main.async {
                    
                    if(self.isMissionCompleted){
                        //Tell user good job, post any necessary notifications  or perform additional processing
                        print("Good Job! THat's what I want!")
                    } else {
                        //Tell user to try again
                        print("No! THat's not what I want!")

                    }
                    
                }
            })
            
            
            
            let handler = VNImageRequestHandler(cgImage: image)
            
            
            do{
                print("Performing the CoreML request")
                try? handler.perform([request])
            } catch {
                print("did throw on performing a VNCoreRequest")
            }
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
        
        setActiveModelTo(coreMLModel: .Resnet50)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        
        

    }
    
    
    @objc func analyzePictureChosenByPlayer(notification: Notification?){
        
        print("NPC has received notification from player, proceeding to analyze the player's chosen picture...")
        
        if let player = notification?.object as? Player, let pickedImage = player.pickedImage?.cgImage{
            
            print("Player reference obtained from notification...")

            acceptImageFromPlayerForAnalysis(pickedImage)
            
            
        }
        
        //TODO: remove observers for notifications
    }
    

    
    
    func registerObserverForNotificationsFromPlayer(player: Player){
        
        NotificationCenter.default.addObserver(self, selector: #selector(analyzePictureChosenByPlayer(notification:)), name: Notification.Name.GetDidSetPickedPictureForPlayer(), object: player)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
 
    
   
}
