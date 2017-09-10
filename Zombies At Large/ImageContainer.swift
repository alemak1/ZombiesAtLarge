//
//  ImageContainer.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class ImageContainer: SKEffectNode{
    
 var imageSpriteNode: SKSpriteNode!
    
 var originalImage: CGImage?
    
    private weak var imageContainer: ImageContainer? //Need to research this
    
    convenience init(image: CGImage, filterName: String, withInputParameters inputParameters: [String:Any]? = nil) {
        
        self.init()
        
        self.filter = CIFilter(name: filterName, withInputParameters: inputParameters)
        
        self.originalImage = image
        let imageTexture = SKTexture(cgImage: image)
        self.imageSpriteNode = SKSpriteNode(texture: imageTexture)
    
        self.addChild(self.imageSpriteNode)
        
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    public func addFilterToEndOfChain(withName filterName: String, andWithInputParameters inputParameters: [String:Any]? = nil){
        
        if let terminalFilter = getTerminalFilterFromLinkedChain(){
            
            terminalFilter.addChildFilter(withName: filterName, andWithInputParameters: inputParameters)
    
        }
    }
    
    
    

    private func getTerminalFilterFromLinkedChain() ->ImageContainer?{
        
        guard self.imageContainer != nil else { return nil }
        
        guard let nextImageContainer = self.imageContainer!.getChildFilter() else { return self.imageContainer! }
        
        return nextImageContainer.getTerminalFilterFromLinkedChain()
        
    }
    
    /** Adds another CIFilter to the current image by first transferring the current image and sprite node to a child SKEffectNode, and then clearing the current image and spriteNode cache **/
    
    private func addChildFilter(withName filterName: String, andWithInputParameters inputParameters: [String:Any]? = nil){
        
        guard self.originalImage != nil else { return }
        
        self.imageContainer = ImageContainer(image: self.originalImage!, filterName: filterName, withInputParameters: inputParameters)
        
        /** The imageSpriteNode is transferred to the imageSpriteNode of the child, after which the current imageSprite node is purged **/
        
        self.imageContainer!.imageSpriteNode = self.imageSpriteNode
        self.imageContainer!.originalImage = self.originalImage
        
        self.imageSpriteNode.move(toParent: self.imageContainer!)
        
        self.imageSpriteNode = nil
        self.originalImage = nil
        
        self.imageContainer!.position = self.position
        
        }
    
    func getChildFilter() -> ImageContainer?{
        return self.imageContainer
    }

    
    
}
