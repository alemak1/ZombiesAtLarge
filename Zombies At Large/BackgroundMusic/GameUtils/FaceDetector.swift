//
//  FaceDetector.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/24/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class FaceDetector{
    
    //MARK: FeatureInfo Key Constants
    
    static let kFaceBounds = "FaceBoundsKey"
    static let kLeftEyePosition = "LeftEyePositionKey"
    static let kRightEyePosition = "RightEyePositionKey"
    static let kMouthPosition = "MouthPositionKey"

    //MARK: TypeAliases for Feature Position Data
    
    typealias FaceBounds = CGRect
    typealias MouthPosition = CGPoint
    typealias LeftEyePosition = CGPoint
    typealias RightEyePosition = CGPoint
    typealias FeatureInfo = [String: Any]
    
    static var sharedDetector = FaceDetector()
    
    var detector: CIDetector!
    
    private init(){
        
        let context = CIContext()
        let opts = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
         self.detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: opts)

    }
    
  
    //MARK: ******** Public Feature Extraction Functions
    
    func getFeatureInfoDict(ciImage: CIImage) -> FeatureInfo{
        
        var featureInfo = FeatureInfo()
        
        let faceBounds = getFeaturesForImage(ciImage: ciImage).first(where: {$0.type == CIFeatureTypeFace})?.bounds
        
        
        let faceFeaturesArray = getFeaturesForImage(ciImage: ciImage).filter({ $0 is CIFaceFeature}) as? [CIFaceFeature]
        
        
        var leftEyePositionInfo: CIFaceFeature?
        var rightEyePositionInfo: CIFaceFeature?
        var mouthPositionInfo: CIFaceFeature?

        if let faceFeatures = faceFeaturesArray{
            
             leftEyePositionInfo = faceFeatures.first(where: {$0.hasLeftEyePosition})
            
             rightEyePositionInfo = faceFeatures.first(where: {$0.hasRightEyePosition})
            
             mouthPositionInfo = faceFeatures.first(where: {$0.hasMouthPosition})
            
            
        }
        
        populateFeatureInfo(featureInfo: &featureInfo, faceBounds: faceBounds, leftEyePosition: leftEyePositionInfo?.leftEyePosition, rightEyePosition: rightEyePositionInfo?.rightEyePosition, mouthPosition: mouthPositionInfo?.mouthPosition)
        
        return featureInfo
        
    }
    
    
    func getFeaturePositions(ciImage: CIImage) -> (FaceBounds?, MouthPosition?,LeftEyePosition?,RightEyePosition?){
        
    
        let faceBounds = getFeaturesForImage(ciImage: ciImage).first(where: {$0.type == CIFeatureTypeFace})?.bounds
        
        let faceFeaturesArray = getFeaturesForImage(ciImage: ciImage).filter({ $0 is CIFaceFeature}) as? [CIFaceFeature]
        
        if let faceFeatures = faceFeaturesArray{
            
            let leftEyePositionInfo = faceFeatures.first(where: {$0.hasLeftEyePosition})
            
            let rightEyePositionInfo = faceFeatures.first(where: {$0.hasRightEyePosition})
            
            let mouthPositionInfo = faceFeatures.first(where: {$0.hasMouthPosition})
            
            
            return (faceBounds,leftEyePositionInfo?.leftEyePosition,rightEyePositionInfo?.rightEyePosition,mouthPositionInfo?.mouthPosition)
            
        }
        
        return (faceBounds,nil,nil,nil)
    
    }
    


    func getRightEyePosition(ciImage: CIImage) -> RightEyePosition?{
        
        let faceFeatures = getFeaturesForImage(ciImage: ciImage).filter({$0 is CIFaceFeature}) as? [CIFaceFeature]
        
        return faceFeatures?.first(where: {$0.hasRightEyePosition})?.rightEyePosition
        
    }
    
    func getLeftEyePosition(ciImage: CIImage) -> LeftEyePosition?{
        
        let faceFeatures = getFeaturesForImage(ciImage: ciImage).filter({$0 is CIFaceFeature}) as? [CIFaceFeature]
        
        return faceFeatures?.first(where: {$0.hasLeftEyePosition})?.leftEyePosition
        
    }
    
  
    func getMouthPosition(ciImage: CIImage) -> MouthPosition?{
        
        let faceFeatures = getFeaturesForImage(ciImage: ciImage).filter({$0 is CIFaceFeature}) as? [CIFaceFeature]
        
        return faceFeatures?.first(where: {$0.hasMouthPosition})?.mouthPosition
        
    }
    
    //MARK: ********* Private Helper Functions
    
    private func getFeaturesForImage(ciImage: CIImage) -> [CIFeature]{
        
        return self.detector.features(in: ciImage)
    }
    
    private func populateFeatureInfo(featureInfo: inout FeatureInfo, faceBounds: FaceBounds?, leftEyePosition: LeftEyePosition?, rightEyePosition: RightEyePosition?, mouthPosition: MouthPosition?){
        
        featureInfo[FaceDetector.kFaceBounds] = faceBounds
        featureInfo[FaceDetector.kLeftEyePosition] = leftEyePosition
        featureInfo[FaceDetector.kRightEyePosition] = rightEyePosition
        featureInfo[FaceDetector.kMouthPosition] = mouthPosition
        
    }
    
    
    //MARK: *********** For Debug Purposes
    
    func getFeaturePositionSummary(ciImage: CIImage) -> String{
        
        let (faceBounds,leftEyePosition,rightEyePosition,mouthPosition) = getFeaturePositions(ciImage: ciImage)
        
        switch (faceBounds,leftEyePosition,rightEyePosition,mouthPosition){
        case (.some,.some,.some,.some):
            return "CIImage has face, left eye position, right eye position, and mouth position"
        case (.some,nil,.some,nil):
            return "CIImage has face and right eye position"
        case (.some,.some,nil,nil):
            return "CIImage has face and left eye position"
        case (.some,nil,nil,.some):
            return "CIImage has face and mouth position"
        case (.some,.some,.some,nil):
            return "CIImage has face, left eye position, and right eye position"
        case (.some,nil,.some,.some):
            return "CIImage has face, right eye position, and mouth position"
        case (.some,.some,nil,.some):
            return "CIImage has face, left eye position, and mouth position"
        default:
            return "CIImage has no identifiable face features"
        }
    }
    
    
}
