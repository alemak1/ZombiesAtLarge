//
//  PlayerProfileStatsTableViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PlayerProfileStatsTableViewController: UITableViewController{
    
    var playerProfile: PlayerProfile?
    
    var sortingCriterion: PlayerProfile.GameStatSortCriteria? = .GameLevelsAscending {
        didSet{
            
            if(oldValue != sortingCriterion){
                
                tableView.reloadData()
            }
        }
    }
    
    var gameLevelStatReviews: [GameLevelStatReview]?{
        
        guard let playerProfile = self.playerProfile, let sortingCriterion = self.sortingCriterion else { return nil }
        
        return playerProfile.getPlayerProfileGameStats(sortedBy: sortingCriterion)
    
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setSortingCriterion(notification:)), name: Notification.Name.GetDidRequestNewSortingCriterionNotification(), object: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    @objc func setSortingCriterion(notification: Notification?){
        
        print("Just received notification to reset the sorting criterion for player game stats view controller")
        
        
        if let sortingCriteriaTBViewController = notification?.object as? SortingCriteriaTableViewController{
            
            self.sortingCriterion = sortingCriteriaTBViewController.selectedCriterion
            
            print("Sorting criterion has been reset to \(self.sortingCriterion!.getSortingClosureName())")

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if playerProfile != nil{
            print("Game stats have been request for player profile with name: \(playerProfile!.name), created on : \(playerProfile!.getFormattedDateString())")
        } else {
            print("No player profile stats available")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let gameLevelStatReviews = self.gameLevelStatReviews else { return 0 }
        
        return gameLevelStatReviews.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameStatsCell", for: indexPath) as? GameStatsCell else { return UITableViewCell() }
        
        guard let gameLevelStatReviews = self.gameLevelStatReviews else { return cell }

        
        let gameLevelStatReview = gameLevelStatReviews[indexPath.row]
        
        let collectiblesValue = Double(gameLevelStatReview.totalValueOfCollectibles)
        let numberOfCollectibles = Int(gameLevelStatReview.totalNumberOfCollectibles)
        let bulletsFired = Int(gameLevelStatReview.numberOfBulletsFired)
        let zombiesKilled = Int(gameLevelStatReview.numberOfZombiesKilled)
        let dateString = gameLevelStatReview.getFormattedDateString()
        let gameLevel = Int(gameLevelStatReview.gameLevel)

        cell.bulletsFiredLabel.text = "Bullets Fired: \(bulletsFired)"
        cell.zombiesKilledLabel.text = "Zombies Killed: \(zombiesKilled)"
        cell.collectiblesValueLabel.text = "Total Value of Collectibles: \(collectiblesValue)"
        cell.numberCollectiblesLabel.text = "Number Of Collectibles: \(numberOfCollectibles)"
        cell.dateLabel.text = dateString
        cell.gameLevelLabel.text = "Level \(gameLevel)"
    
        return cell

    }
    
    @IBAction func unwindBackToPlayerProfileTBViewController(segue: UIStoryboardSegue){
        
    }
}
