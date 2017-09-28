//
//  GameViewController+GameplayUI.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/28/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController{
    
    
    @objc func showCollectionView(){
        
        
        self.itemCollectionView.reloadData()
        
        self.itemViewWindowCenterXConstraint.constant = 0
        self.itemDetailsViewCenterXConstraint.constant = 0
        
        self.itemViewingWindow.layoutIfNeeded()
        
    }
    
    func showItemDetails(forCollectible collectible: Collectible){
        
        if !collectible.getCanBeActivatedStatus(){
            collectibleIsActiveLabel.isEnabled = false
            collectibleIsActiveSwitch.isEnabled = false
            collectibleIsActiveLabel.isHidden = true
            collectibleIsActiveSwitch.isHidden = true
            
        } else {
            collectibleIsActiveLabel.isEnabled = true
            collectibleIsActiveSwitch.isEnabled = true
            
            collectibleIsActiveLabel.isHidden = false
            collectibleIsActiveSwitch.isHidden = false
            
            let activeStatus = collectible.getActiveStatus()
            collectibleIsActiveSwitch.isOn = activeStatus
            
            let labelText = activeStatus ? "Deactivate":"Activate"
            collectibleIsActiveLabel.text = labelText
            
        }
        
        itemTitleLabel.text = "Item Name: \(collectible.getCollectibleName())"
        itemQuantityLabel.text = "Quantity: \(collectible.getQuantityOfCollectible())"
        itemDetailsImage.image = UIImage(cgImage: collectible.getCollectibleTexture().cgImage())
        
        totalMassLabel.text = "Total Mass: \(collectible.getCollectibleMass())"
        totalUnitValueLabel.text = "Unit Value: \(collectible.getCollectibleUnitValue())"
        totalMonetaryValueLabel.text = "Total Monetary Value: \(collectible.getCollectibleMonetaryValue())"
        unitMetalContentLabel.text = "% Metal Content: \(collectible.getPercentMetalContentByUnit())"
        totalMetalContentLabel.text = "Total Metal Content: \(collectible.getCollectibleMetalContent())"
        
        UIView.animate(withDuration: 0.70, animations: {
            
            if(!self.itemDetailsAreDisplayed){
                self.itemDetailsViewCenterYConstraint.constant += 150
                self.itemViewWindowCenterYConstraint.constant -= 150
                self.view.layoutIfNeeded()
                self.itemDetailsAreDisplayed = true
            }
            
        })
        
        
        
    }
    
     func dismissItemDetails(){
        
        self.itemViewWindowCenterYConstraint.constant += 150
        self.itemDetailsViewCenterYConstraint.constant -= 150
        
        
        UIView.animate(withDuration: 0.60, animations: {
            
            self.view.layoutIfNeeded()
            
            
        }, completion: { animationsFinished in
            
            if(animationsFinished){
                
                self.itemDetailsAreDisplayed = false
                self.currentlySelectedItem = nil
            }
            
        })
    }
    
 func showItemDetailInformation(){
        
        self.detailInformationCenterXConstraint.constant = 0
        self.detailInfoLabel.alpha = 1.00
        
        self.itemInfoLabelsAlignLeftConstraint.constant += 1000
        self.totalMetalContentLabel.alpha = 0.00
        self.totalMonetaryValueLabel.alpha = 0.00
        self.unitMetalContentLabel.alpha = 0.00
        self.totalUnitValueLabel.alpha = 0.00
        
        
        if let currentIndex = self.currentlySelectedItem, let detailInfo = collectibleManager?.getCollectibleAtIndex(index: currentIndex)?.getCollectibleType().getDetailInformation(){
            
            self.detailInfoLabel.text = detailInfo
            
        }
        
        UIView.animate(withDuration: 0.50, animations: {
            
            /**
             let angle = self.itemDetailInfoIsShowing ? 0.00 : CGFloat.pi/2
             
             self.itemDetailWindow.transform = CGAffineTransform(rotationAngle: angle)
             **/
            
            
            self.view.layoutIfNeeded()
            
            
        }, completion: {
            
            isFinishedAnimating in
            
            if(isFinishedAnimating){
                self.itemDetailInfoIsShowing = !self.itemDetailInfoIsShowing
            }
            
        })
        
    }
    
    
}
