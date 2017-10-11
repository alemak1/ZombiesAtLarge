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
import GoogleMobileAds

class SavedGamesViewController: UITableViewController{
    
    var playerProfile: PlayerProfile!
    
    var savedGames: [SavedGame]?{
        
        return playerProfile.getSavedGames()
        
    }
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-3595969991114166/3880912913"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GADRequest()
        request.testDevices = ["3f6b9063183db11d680edcf5f59d8f62"]
        adBannerView.load(request)

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
            
            cell.savedGame = savedGame
            
            
            
            
        
        }
        
        return cell
    }
}


extension SavedGamesViewController: GADBannerViewDelegate{
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.tableView.tableHeaderView = bannerView
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    
    
}
