//
//  GameStatsNavigationController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit

class GameStatsNavigationController: UINavigationController{
    
    var playerProfile: PlayerProfile?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let statsTableViewController = self.viewControllers.first as? PlayerProfileStatsTableViewController{
            
            statsTableViewController.playerProfile = playerProfile
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
