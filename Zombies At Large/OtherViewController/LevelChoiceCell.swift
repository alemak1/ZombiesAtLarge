//
//  LevelChoiceCell.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit

class LevelChoiceCell: UICollectionViewCell{
    @IBAction func loadSelectedLevel(_ sender: UIButton) {
    }
    
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var levelTitleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var levelTitleTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var levelThumbnail: UIImageView!
    
    @IBOutlet weak var descriptionLabelCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabelCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var levelDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var levelTitleLabel: UILabel!
    
    var gameLevel: GameLevel!

    func animateConstraintsUponSelection(){


        levelTitleTopConstraint.constant += 40
        descriptionLabelCenterXConstraint.constant += 200
        
        
        UIView.animate(withDuration: 0.50, animations: {
            
            self.contentView.layoutIfNeeded()
            
        })
    }
    
    func animateConstraintsUponDeselection(){
        

        levelTitleTopConstraint.constant -= 40
        descriptionLabelCenterXConstraint.constant -= 200
        UIView.animate(withDuration: 0.50, animations: {
            
            self.contentView.layoutIfNeeded()
            
        })
    }
    
    func resetTitleLabelHeightConstraint(){
        contentView.constraints.forEach({
            constraint in
            
            if constraint.identifier == "titleHeightConstraint"{
                constraint.isActive = false
            }
            
            let newConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: isSelected ? 0.3:0.8, constant: 0.00)
            
            newConstraint.identifier = "titleHeightConstraint"
            newConstraint.isActive = true
        })

    }
    
}
