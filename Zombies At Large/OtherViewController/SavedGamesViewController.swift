//
//  SavedGamesViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class SavedGamesViewController: UITableViewController{
    
    var playerProfile: PlayerProfile!
    
    var savedGames: [SavedGame]?{
        
        return playerProfile.getSavedGames()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let savedGames = self.savedGames else { return 0 }
        
        return savedGames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedGameCell", for: indexPath) as! SavedGameCell
        
        if let savedGames = self.savedGames{
            
            let savedGame = savedGames[indexPath.row]
            
            let dateStr = savedGame.getFormattedDateString()
            
            cell.dateSaved.text = dateStr
            
            let gameLevelInt = Int(savedGame.level)
            
            cell.levelTitle.text = "Level \(gameLevelInt)"
            
            let gameLevel = GameLevel(rawValue: gameLevelInt)!
            
            let levelDescription = gameLevel.getFullGameMissionDescription()
            
            cell.missionDescription.text = levelDescription
        
        }
        
        return cell
    }
}
