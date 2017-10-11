//
//  SavedGameCell.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit

class SavedGameCell: UITableViewCell{
    
    
    var savedGame: SavedGame!
    
    
    @IBAction func loadSavedGame(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: Notification.Name.GetDidRequestSavedGameToBeLoadedNotification(), object: self, userInfo: nil)
    }
    
    @IBOutlet weak var missionDescription: UILabel!
    
    @IBOutlet weak var dateSaved: UILabel!
    
    @IBOutlet weak var levelTitle: UILabel!
    
    
    
}
