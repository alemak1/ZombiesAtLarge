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
    
    @IBOutlet weak var levelThumbnail: UIImageView!
    
    @IBOutlet weak var descriptionLabelCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabelCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var levelDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var levelTitleLabel: UILabel!
    
    func animateConstraintsUponSelection(){
        
    }
    
    func animateConstraintsUponDeselection(){
        
    }
    
}
