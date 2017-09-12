//
//  FilterConfiguration.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/11/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CoreImage

protocol FilterConfiguration{
    
    var filterName: String { get set}
    var imageName: String { get set}
    
    init(andWithImageName imageName: String)

    func getParameterDict() -> [String:Any]?
}


struct SepiaToneFilterConfiguration: FilterConfiguration{
    
    var filterName: String
    var imageName: String
    
    
    init(andWithImageName imageName: String){

        self.init(withFilterName: FilterNames.SepiaTone, andWithImageName: imageName)
    }
    
    private init(withFilterName filterName: String, andWithImageName imageName: String) {
        self.filterName = filterName
        self.imageName = imageName
    }
    
    func getParameterDict() -> [String : Any]? {
        
        guard let cgImage = UIImage(named: self.imageName)?.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        return [kCIInputImageKey: ciImage]
    
        
    }
    
}

struct DiscBlurFilterConfiguration: FilterConfiguration{
    var inputRadius: Double = 8.00
    var filterName: String
    var imageName: String
    
    init(imageName: String, andWithInputRadius inputRadius: Double) {
        self.init(withFilterName: FilterNames.DiscBlur, andWithImageName: imageName)
        self.inputRadius = inputRadius
    }
    
    init(andWithImageName imageName: String){
        self.init(withFilterName: FilterNames.DiscBlur, andWithImageName: imageName)
    }

    
    private init(withFilterName filterName: String, andWithImageName imageName: String) {
        self.filterName = filterName
        self.imageName = imageName
    }
    
    func getParameterDict() -> [String : Any]? {
        
        guard let cgImage = UIImage(named: self.imageName)?.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        return [kCIInputImageKey: ciImage, kCIInputRadiusKey:inputRadius]
        
        
    }

}


struct GaussianBlurConfiguration{
    
    var inputRadius: Double = 8.00
    var filterName: String
    var imageName: String
    
    init(imageName: String, andWithInputRadius inputRadius: Double) {
        self.init(withFilterName: FilterNames.DiscBlur, andWithImageName: imageName)
        self.inputRadius = inputRadius
    }
    
    init(andWithImageName imageName: String){
        self.init(withFilterName: FilterNames.DiscBlur, andWithImageName: imageName)
    }
    
    
    private init(withFilterName filterName: String, andWithImageName imageName: String) {
        self.filterName = filterName
        self.imageName = imageName
    }
    
    func getParameterDict() -> [String : Any]? {
        
        guard let cgImage = UIImage(named: self.imageName)?.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        return [kCIInputImageKey: ciImage, kCIInputRadiusKey:inputRadius]
        
        
    }
}

class FilterNames{
    
    static let CategoryBlur = "CICategoryBlur"
    static let DiscBlur = "CIDiscBlur"
    static let SepiaTone = "CISepiaTone"
    static let GaussianBlur = "CIGaussianBlur"
    static let Pixellate = "CIPixellate"
    static let allFilterNames = [FilterNames.CategoryBlur, FilterNames.DiscBlur,FilterNames.SepiaTone]
    
    static func GetRandomFilterName() -> String{
        
        let randomIdx = Int(arc4random_uniform(UInt32(FilterNames.allFilterNames.count)))
        
        return FilterNames.allFilterNames[randomIdx]
    }
}



