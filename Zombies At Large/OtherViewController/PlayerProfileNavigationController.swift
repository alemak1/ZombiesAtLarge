//
//  PlayerProfileNavigationController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/2/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerProfileNavigationController: UINavigationController{
    
    var selectedPlayerProfile: PlayerProfile?{
        
        get{
            if let mainMenuController = self.presentingViewController as? MainMenuController{
                return mainMenuController.selectedPlayerProfile
            }
            return nil
        }
        
        set(newPlayerProfile){
            if let mainMenuController = self.presentingViewController as? MainMenuController{
                mainMenuController.selectedPlayerProfile = newPlayerProfile
            }
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
