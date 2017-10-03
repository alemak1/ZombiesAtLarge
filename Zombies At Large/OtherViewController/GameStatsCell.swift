//
//  GameStatsCell.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class GameStatsCell: UITableViewCell{
    
    /** GameStatCell Outlets **/
    
    @IBOutlet weak var gameLevelLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bulletsFiredLabel: UILabel!
    @IBOutlet weak var zombiesKilledLabel: UILabel!
    @IBOutlet weak var numberCollectiblesLabel: UILabel!
    @IBOutlet weak var collectiblesValueLabel: UILabel!
    

    
    override func didMoveToWindow() {
        super.didMoveToWindow()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
}
