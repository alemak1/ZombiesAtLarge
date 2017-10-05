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
    
    
    var selectedLevelChoiceCell: LevelChoiceCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! LevelChoiceCell
        
        cell.animateConstraintsUponSelection()
        
        self.selectedLevelChoiceCell = cell
        
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
        let gameLevel = cellInfo.rawValue
        let levelDescription = cellInfo.getFullGameMissionDescription()
        let levelThumbnail = cellInfo.getLevelThumbnail()
        
        cell.levelDescriptionLabel.text = levelDescription
        cell.levelTitleLabel.text = "Level \(gameLevel)"
        cell.levelThumbnail.image = levelThumbnail
        
        return cell
    }
}
