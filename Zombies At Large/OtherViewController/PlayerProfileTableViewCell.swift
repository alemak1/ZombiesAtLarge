//
//  PlayerProfileTableViewCell.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit

class PlayerProfileTableViewCell: UITableViewCell{
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    var playerProfile: PlayerProfile!
    
    
    @IBAction func getDetailsButton(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name.GetDidRequestPlayerProfileStatsTBViewController(), object: self, userInfo: nil)
        
    }
    
    

    
    override func didMoveToWindow() {
        super.didMoveToWindow()
    
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    
}
