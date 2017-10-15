//
//  RandomObjectStringGenerator.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit


class RandomObjectStringGenerator{
    
    
    static let RandomMiscellaneousStrings = [
        "banana",
        //"bottle",
       // "chair",
       // "knife",
      //  "TV"
       // "banana",
       // "apple",
       // "car",
       // "computer",
       // "shirt"
    ]
    
    
    static func GetRandomString() -> String{
        
        let randomIdx = Int(arc4random_uniform(UInt32(RandomObjectStringGenerator.RandomMiscellaneousStrings.count)))
        
        return RandomObjectStringGenerator.RandomMiscellaneousStrings[randomIdx]
    }
}
