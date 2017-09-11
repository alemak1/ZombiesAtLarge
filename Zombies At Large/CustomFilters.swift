//
//  CustomFilters.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/11/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import CoreImage

/**
class SepiaPixellateFilter: CIFilter{
    
    var inputScale: Double
    var inputCenter: CIVector
    
    var inputImage: CIImage


    private var sepiaFilterIsActive = true
    private var pixellateFilterIsActive = true
    
    override func setDefaults() {
        super.setDefaults()
        
        let defaultPoint = CGPoint(x: 150, y: 150)
        let defaultCenter = CIVector(cgPoint: defaultPoint)
        setValue(defaultCenter, forKey: kCIInputCenterKey)
        setValue(8.00, forKey: kCIInputScaleKey)
    }
    
    override var outputImage: CIImage?{
        
        var modifiedImage = inputImage
        
        if(sepiaFilterIsActive){
            let sepiaToneFilter = CIFilter(name: FilterNames.SepiaTone)
            setValue(modifiedImage, forKey: kCIInputImageKey)

            if let outputImage = sepiaToneFilter!.outputImage{
                modifiedImage = outputImage
            }
        }
        
        if(pixellateFilterIsActive){
            
            let pixellateFilter = CIFilter(name: FilterNames.Pixellate)
            setValue(modifiedImage, forKey: kCIInputImageKey)
       
            
            
            if let outputImage = pixellateFilter!.outputImage{
                modifiedImage = outputImage
            }
        }
        
    }
}

class MutableSepiaPixellateFilter: CIFilter{
    
}
 **/
