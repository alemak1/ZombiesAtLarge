//
//  ScrollManager.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/28/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
//

import Foundation
import Swift



struct LexicalClassDistribution{
       var numberOfNouns: Int = 0
        var numberOfVerbs: Int = 0
        var numberOfAdjective: Int = 0
        var numberOfAdverbs: Int = 0
        var numberOfPronouns: Int = 0
        var numberOfPrepositions: Int = 0
        var numberOfDeterminers: Int = 0
        var numberOfConjunctions: Int = 0
        var numberOfParticles: Int = 0
        var numberOfNumbers: Int = 0
        var numberOfInterjections: Int = 0
        var numberOfClassifiers: Int = 0
        var numberOfOtherWords: Int = 0
        var numberOfIdioms: Int = 0
}

class ScrollManager{
    
 
    var allScrolls = [ScrollConfiguration]()
    var currentIndex: Int = 0
    
    let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass,.tokenType], options: 0)
    
    
    func addScrollConfiguration(scrollConfiguration: ScrollConfiguration){
        
        self.allScrolls.append(scrollConfiguration)
        
    }
    
    
    func getTotalNumberOfWords(atIndex index: Int) -> Int{
        
        self.currentIndex = index
        
        return getTotalNumberOfWordsForCurrentScroll()
    }
    
    func getLexicalClassDistribution(atIndex index: Int) -> LexicalClassDistribution{
        
        self.currentIndex = index
        
        return getLexicalClassDistributionForCurrentScroll()
    }
    
    func getLexicalClassDistributionForCurrentScroll() -> LexicalClassDistribution{
        
        var lexicalClassDist = LexicalClassDistribution()
        
        for idx in 0..<getTotalNumberOfWordsForCurrentScroll() {
            
            guard let tag = tagger.tag(at: idx, unit: .word, scheme: .lexicalClass, tokenRange: nil) else {
                break
            }
            
            switch tag{
            case .noun:
                lexicalClassDist.numberOfNouns += 1
                break
            case .verb:
                lexicalClassDist.numberOfVerbs += 1
                break
            case .adjective:
                lexicalClassDist.numberOfAdjective += 1
                break
            case .adverb:
                lexicalClassDist.numberOfAdverbs += 1
                break
            case .pronoun:
                lexicalClassDist.numberOfPronouns += 1
                break
            case .determiner:
                lexicalClassDist.numberOfDeterminers += 1
                break
            case .preposition:
                lexicalClassDist.numberOfPrepositions += 1
                break
            case .particle:
                lexicalClassDist.numberOfParticles += 1
                break
            case .conjunction:
                lexicalClassDist.numberOfConjunctions += 1
                break
            case .number:
                lexicalClassDist.numberOfNumbers += 1
                break
            case .interjection:
                lexicalClassDist.numberOfInterjections += 1
                break
            case .otherWord:
                lexicalClassDist.numberOfOtherWords += 1
                break
            case .idiom:
                lexicalClassDist.numberOfIdioms += 1
                break
            case .classifier:
                lexicalClassDist.numberOfClassifiers += 1
                break
            default:
                break
            }
        }
        
        return lexicalClassDist
    }
    
    func getTotalNumberOfWordsForCurrentScroll() -> Int{
        
        if(allScrolls.count <= 0){
            return 0
        }
    
        let currentText = allScrolls[currentIndex].text
        
        tagger.string = currentText
        
        let range = NSRange(location: 0, length: currentText.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]

        var allWords = [String]()
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { _, tokenRange, _ in
            let word = (currentText as NSString).substring(with: tokenRange)
            allWords.append(word)
        }
        
        return allWords.count
    }
    
    
}
