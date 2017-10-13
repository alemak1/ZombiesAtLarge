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
import GoogleMobileAds

class PlayerProfileStatsTableViewController: UITableViewController{
    
    var playerProfile: PlayerProfile?
    
    
    @IBAction func dimissStatsViewController(_ sender: Any) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-3595969991114166/7017431896"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    

    var sortingCriterion: PlayerProfile.GameStatSortCriteria? = .GameLevelsAscending {
        didSet{
            
            if(oldValue != sortingCriterion){
    
                _gameLevelStatReviews = nil
                tableView.reloadData()
            }
        }
    }
    
    private var _gameLevelStatReviews: [GameLevelStatReview]? = nil
        
    
    var gameLevelStatReviews: [GameLevelStatReview]?{
        
        get{
            if(_gameLevelStatReviews != nil){
                return _gameLevelStatReviews
            } else {
                
                guard let playerProfile = self.playerProfile, let sortingCriterion = self.sortingCriterion else { return nil }
            
                 _gameLevelStatReviews = playerProfile.getGameStatReviews(forSortingCriteria: sortingCriterion)
                
                return _gameLevelStatReviews
                
            }
        }
       
        set(newValue){
            _gameLevelStatReviews = newValue
        }
    
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setSortingCriterion(notification:)), name: Notification.Name.GetDidRequestNewSortingCriterionNotification(), object: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adBannerView.load(GADRequest())

        tableView.reloadData()
    }
    
    @objc func setSortingCriterion(notification: Notification?){
        
        print("Just received notification to reset the sorting criterion for player game stats view controller")
        
        
        if let sortingCriteriaTBViewController = notification?.object as? SortingCriteriaTableViewController{
            
            self.gameLevelStatReviews = nil
            self.sortingCriterion = nil
            self.sortingCriterion = sortingCriteriaTBViewController.selectedCriterion
            
            let _ = self.gameLevelStatReviews
            
            print("Sorting criterion has been reset to \(self.sortingCriterion!.getSortingClosureName())")
            
            self.tableView.reloadData()

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if playerProfile != nil{
            print("Game stats have been request for player profile with name: \(playerProfile!.name), created on : \(playerProfile!.getFormattedDateString())")
            tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adBannerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return adBannerView.frame.height
    }

}

extension PlayerProfileStatsTableViewController: GADBannerViewDelegate{
    
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
