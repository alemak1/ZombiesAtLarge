//
//  Classification.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//


import Foundation
import CoreML
import Vision

struct ClassificationResult{
    
    enum ConfidenceLevel{
        case ExtremelyHigh
        case VeryHigh
        case High
        case Sufficent
        case Insufficient
        case NoData
    }
    
    var results: [VNClassificationObservation]
    
    init(withClassificationObservations classificationObservations: [VNClassificationObservation]) {
        
        results = classificationObservations
    }
    
    func getMostProbableClassification() -> VNClassificationObservation?{
        
        return results.first
    }
    
    
    
    
    
    func isClassificationSufficient() -> Bool{
        
        let topThreeResults = getTopThreeMostProbableClassifications()
        
        let topThreeCombined: Float = topThreeResults.map { $0.confidence}.reduce(0.00,+)
        
        return topThreeCombined >= 0.70
    }
    
    
    func getTopThreeMostProbableClassifications() -> [VNClassificationObservation]{
        
        var mostProbablyClassifications = [VNClassificationObservation]()
        var count = 0
        
        repeat{
            mostProbablyClassifications.append(results[count])
            count += 1
        } while(count < 3)
        
        return mostProbablyClassifications
    }
    
    
    func getHighestConfidenceLevel() -> ConfidenceLevel{
        
        guard  results.first != nil else { return .NoData }
        
        let mostProbableResult = results.first!
        
        let tupleResult = (mostProbableResult.identifier,mostProbableResult.confidence)
        
        switch tupleResult{
        case let (_,confidence) where confidence >= 0.95:
            return .ExtremelyHigh
        case let (_,confidence) where confidence >= 0.90:
            return .VeryHigh
        case let (_,confidence) where confidence >= 0.80:
            return .High
        case let (_,confidence) where confidence >= 0.70:
            return .Sufficent
        default:
            return .Insufficient
        }
        
    }
    
    func getClassificationObservationWithHighestConfidence() -> VNClassificationObservation?{
        
        return self.results.max{ obsFirst, obsSecond in obsFirst.confidence < obsSecond.confidence }
    }
    
    
    func getResultsInTupleFormat() -> [(String,Float)]{
        
        return results.map{($0.identifier,$0.confidence)}
    }
    
    func showResults(){
        
        let tupleFormattedResults = getResultsInTupleFormat()
        
        for tupleResult in tupleFormattedResults {
            print("There is a \(tupleResult.1) confidence that the photographed object is a \(tupleResult.0)")
            
        }
        
    }
    
    func getDetailedDebugDescription(){
        
        if let highestConfidenceObservation = getClassificationObservationWithHighestConfidence(){
            print("getClassificationObservationWithHigestConfidence() produces the output: ")
            
            print("The highest confidence observation has a confidence level of: \(highestConfidenceObservation.confidence)")
        }
        
        let highestConfidenceLevel = getHighestConfidenceLevel()
        
        switch highestConfidenceLevel {
        case .ExtremelyHigh:
            print("The model result has EXTREMELY HIGH confidence")
            break
        case .VeryHigh:
            print("The model result has VERY HIGH confidence")
            break
        case .High:
            print("The model result has HIGH confidence")
            break
        case .Sufficent:
            print("The model result has SUFFICIENT confidence")
            break
        case .Insufficient:
            print("The model result has INSUFFICENT confidence")
            break
        case .NoData:
            print("No data available for the model")
            
        }
        
        guard isClassificationSufficient() else {
            print("The model produces a classification whose confidence leve is insufficent ")
            return
        }
        
        print("The model produces a confidence level that is sufficient.  The top three results are shown below: ")
        
        for classification in getTopThreeMostProbableClassifications() {
            
            print("Classification Name: \(classification.identifier), Confidence Level: \(classification.confidence)")
        }
        
    }
    
}
