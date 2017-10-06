//
//  PlayerProfileViewController+HelperFunctions.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/6/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit

extension PlayerProfileViewController{
    
    func setDelegateAndDataSourcePropertiesForUIElements(){
        
        self.nameTextField.delegate = self
        
        self.avatarPicker.delegate = self
        self.avatarPicker.dataSource = self
        
        self.specialWeaponCollectionView.dataSource = self
        self.specialWeaponCollectionView.delegate = self
        self.specialWeaponCollectionView.tag = PlayerProfileCollectionViewTag.SpecialWeaponCV.rawValue
        self.specialWeaponCollectionView.backgroundColor = UIColor.clear
        
        self.upgradeObjectCollectionView.dataSource = self
        self.upgradeObjectCollectionView.delegate = self
        self.upgradeObjectCollectionView.tag = PlayerProfileCollectionViewTag.UpgradeObjectCV.rawValue
        self.upgradeObjectCollectionView.backgroundColor = UIColor.clear
        
    }
    
    /** Helper functions that reset the UIElements based on an existing player profile that the user can edit.  The selected player profile can be force unwrapped for each of these functions because they are only called for codepaths where nil checking is done for the selected player profile **/
    
    func resetAvatarBasedOnPlayerProfile(){
        var playerTypeIdx = 0
        
        for (idx,playerType) in PlayerType.allPlayerTypes.enumerated(){
            
            if(playerType.getIntegerValue() == Int(selectedPlayerProfile!.playerType)){
                playerTypeIdx = idx
            }
        }
        
    
        self.selectedPlayerType = PlayerType(withIntegerValue: Int(selectedPlayerProfile!.playerType))
        
        self.avatarPicker.selectRow(playerTypeIdx, inComponent: 0, animated: true)

        
    }
    
    func resetUpgradeObjectDetailViewBasedOnPlayerProfile(){
        if let upgradeObject = CollectibleType(rawValue: Int(self.selectedPlayerProfile!.upgradeCollectible)){
            
            self.selectedUpgradeItemType = upgradeObject
            self.upgradeObjectImageView.contentMode = .scaleAspectFit
            self.upgradeObjectImageView.image = UIImage(cgImage: upgradeObject.getTexture().cgImage())
            self.upgradeObjectLabel.text = upgradeObject.getCollectibleName()
        }
    }
    
    func resetSpecialWeaponDetailViewBasedOnPlayerProfile(){
        if let specialWeapon = CollectibleType(rawValue: Int(self.selectedPlayerProfile!.specialWeapon)){

            self.selectedSpecialWeaponType = specialWeapon
            specialWeaponImageView.contentMode = .scaleAspectFit
            self.specialWeaponImageView.image = UIImage(cgImage: specialWeapon.getTexture().cgImage())
            self.specialWeaponLabel.text = specialWeapon.getCollectibleName()
            
        }
    }
    
    func resetNameFieldTextBasedOnPlayerProfile(){
        self.nameTextField.text = selectedPlayerProfile!.name
        self.nameTextField.setNeedsDisplay()
        
        
    }
    
    func positionSpecialWeaponDetailViewOnScreen(){
        
        self.specialWeaponDetailVewCenterXConstraint.constant = 0
        self.chooseWeaponLableCenterXConstraint.constant = -1000
      
   
    }
    
    func positionUpgradeObjectDetailViewOnScreen(){
        
        
        self.upgradeObjectDetailViewCenterXConstraint.constant = 0
        self.chooseUpgradeObjectLabelCenterXConstraint.constant = -1000
        
    }
    
    func positionDetailViewsOffScreen(){
        
        self.specialWeaponDetailVewCenterXConstraint.constant = 1000
        self.upgradeObjectDetailViewCenterXConstraint.constant = 1000
        
    }
    
    func positionCollectionViewsOffScreen(){
        self.specialWeaponCollectionViewCenterXConstraint.constant = -1000
        self.upgradeObjectCollectionViewCenterXConstraint.constant = -1000
        
    }
    
}
