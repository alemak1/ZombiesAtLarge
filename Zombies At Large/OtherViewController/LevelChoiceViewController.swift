//
//  LevelChoiceViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class LevelChoiceViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var activityIndicatorCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionViewCenterXConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var loadSelectedGameButton: UIButton!
    
    @IBAction func loadSelectedGame(_ sender: Any) {
        
        
        if self.selectedLevelChoiceCell == nil{
            
            let alertViewController = UIAlertController(title: "No Game Level Selected", message: "Choose a Game Level in order to load a game", preferredStyle: .alert)
            
            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            
            alertViewController.addAction(okay)
            
            present(alertViewController, animated: true, completion: nil)
            
            return
            
        } else {
            
            showActivityIndicator()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20, execute: {
                
                self.performSegue(withIdentifier: "loadSelectedLevelSegue", sender: nil)
                
            })
            

        }
      
        
    
    }
    
    var playerProfile: PlayerProfile?
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "loadSelectedLevelSegue" && self.selectedLevelChoiceCell == nil{
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if(segue.identifier == "loadSelectedLevelSegue"){
            
            if let gameViewController = segue.destination as? GameViewController{
                gameViewController.selectedGameLevel = self.selectedGameLevel
                gameViewController.playerProfile = self.playerProfile
                
            }
        }
        
    }
    
    var selectedLevelChoiceCell: LevelChoiceCell?{
        didSet{
            
            if(oldValue != selectedLevelChoiceCell){
                
                loadSelectedGameButton.titleLabel?.text = selectedLevelChoiceCell == nil ? "Select Game Level":"Load Selected Level"

            }
        }
    }
    
    var selectedGameLevel: GameLevel?{
        
        guard let gameLevel = selectedLevelChoiceCell?.gameLevel else { return nil }
        
        return gameLevel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicatorCenterXConstraint.constant = -2000
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartCurrentGame(notification:)), name: Notification.Name.GetDidRequestGameRestartNotification(), object: nil)
        
    }
    
    @objc func restartCurrentGame(notification: Notification?){
        
        var restartLevel: GameLevel = .Level1
        
        guard let restartGameScene = notification?.object as? GameScene else {
            
            return
        }
        
        
        restartLevel = restartGameScene.currentGameLevel

        
        if let getNextLevel = notification?.userInfo?["getNextLevel"] as? Bool{
            
            if(getNextLevel){
                
                restartLevel = restartGameScene.currentGameLevel.getNextLevel()
                
            }
            
        }
            

        
        
        if let gameViewController  = self.presentedViewController as? GameViewController{
            
            
            gameViewController.dismiss(animated: true, completion: nil)
            
        } else {
            
            return
        }
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let gameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        
        
        gameViewController.playerProfile = self.playerProfile
        gameViewController.savedGame = nil
        gameViewController.selectedGameLevel = restartLevel
        
        present(gameViewController, animated: true, completion: nil)
        
        
        
    }
    
    
    func showActivityIndicator(){
        
        self.activityIndicator.startAnimating()
        self.activityIndicatorCenterXConstraint.constant += 2000
        self.collectionViewCenterXConstraint.constant += 2000
        
        UIView.animate(withDuration: 0.50, animations: {
            
            self.view.layoutIfNeeded()
        })

    }
    
    func removeActivityIndicator(){
        
        self.activityIndicator.stopAnimating()

        self.activityIndicatorCenterXConstraint.constant -= 2000
        self.collectionViewCenterXConstraint.constant -= 2000
        
        UIView.animate(withDuration: 0.50, animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! LevelChoiceCell
        
        if cell == self.selectedLevelChoiceCell{
            return
        } else {

            cell.animateConstraintsUponSelection()
        
            self.selectedLevelChoiceCell = cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        

        if let previouslySelectedCell = self.selectedLevelChoiceCell{

            previouslySelectedCell.animateConstraintsUponDeselection()
            self.selectedLevelChoiceCell = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return GameLevel.AllGameLevels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelChoiceCell", for: indexPath) as! LevelChoiceCell
        
        
        let cellInfo = GameLevel.AllGameLevels[indexPath.row]
        cell.gameLevel = cellInfo
        
        let gameLevel = cellInfo.rawValue
        let levelThumbnail = cellInfo.getLevelThumbnail()
        
        
        
        cell.levelDescriptionLabel.text = playerProfile!.hasCompletedGameLevel(gameLevel: cellInfo) ? "Complete":"Incomplete"
        
        cell.levelTitleLabel.text = "Level \(gameLevel)"
        cell.levelThumbnail.image = levelThumbnail
        
        return cell
    }
}
