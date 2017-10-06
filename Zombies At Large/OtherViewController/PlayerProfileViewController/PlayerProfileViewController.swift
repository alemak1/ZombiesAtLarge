//
//  PlayerProfileViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import GoogleMobileAds

enum PlayerProfileCollectionViewTag: Int{
        case SpecialWeaponCV = 1
        case UpgradeObjectCV = 2
}

class PlayerProfileViewController: UIViewController{
    

    
    var willCreateNewProfile = false
    
    var selectedPlayerProfile: PlayerProfile?{
    
        get{
            if let mainMenuController = self.presentingViewController as? MainMenuController{
            
                return mainMenuController.selectedPlayerProfile
            
            } else if let profileTableViewVC = self.presentingViewController as? PlayerProfileTableViewController{
            
                return profileTableViewVC.selectedPlayerProfile
                
            } else if let playerProfileNavigationController = self.presentingViewController as? PlayerProfileNavigationController {
                
                return playerProfileNavigationController.selectedPlayerProfile

            } else if let rootViewController = self.navigationController?.viewControllers.first as? PlayerProfileNavigationController  {
                return rootViewController.selectedPlayerProfile
            } else {
                return nil
            }
        }
        
        set(newPlayerProfile){
            if let mainMenuController = self.presentingViewController as? MainMenuController{
                
                mainMenuController.selectedPlayerProfile = newPlayerProfile
                
            } else if let profileTableViewVC = self.presentingViewController as? PlayerProfileTableViewController{
                
                profileTableViewVC.selectedPlayerProfile = newPlayerProfile
                
            } else if let playerProfileNavigationController = self.presentingViewController as? PlayerProfileNavigationController {
                
                 playerProfileNavigationController.selectedPlayerProfile = newPlayerProfile
                
            } else if let rootViewController = self.navigationController?.viewControllers.first as? PlayerProfileNavigationController  {
                return rootViewController.selectedPlayerProfile = newPlayerProfile
            }
            
        }
    }
    
    /** IB Outlets and Actions **/
    
    @IBOutlet weak var chooseWeaponLableCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var chooseUpgradeObjectLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var specialWeaponImageView: UIImageView!
    @IBOutlet weak var specialWeaponLabel: UILabel!
    @IBOutlet weak var upgradeObjectImageView: UIImageView!
    @IBOutlet weak var upgradeObjectLabel: UILabel!
    
    @IBOutlet weak var specialWeaponCollectionViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var specialWeaponDetailVewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var upgradeObjectDetailViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var upgradeObjectCollectionViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var avatarPicker: UIPickerView!
    @IBOutlet weak var specialWeaponCollectionView: UICollectionView!
    @IBOutlet weak var upgradeObjectCollectionView: UICollectionView!
    
    
    @IBAction func submitPlayerName(_ sender: UIButton) {
        
        if(nameTextField.text == nil || (nameTextField.text != nil && nameTextField.text!.isEmpty)){
            showMessage(title: "No Name Entered", message: "Please enter a valid player name")
            return
        }
        
        if(nameTextField.isFirstResponder){ nameTextField.resignFirstResponder()
        }
    }
    @IBAction func showUpgradeObjectCV(_ sender: UIButton) {
        
        self.upgradeObjectCollectionViewCenterXConstraint.constant += 1000
        self.chooseUpgradeObjectLabelCenterXConstraint.constant -= 1000
        self.upgradeObjectCollectionView.reloadData()

        UIView.animate(withDuration: 0.50, animations: {
            
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func showSpecialWeaponCV(_ sender: UIButton) {
        
        self.specialWeaponCollectionViewCenterXConstraint.constant += 1000
        self.chooseWeaponLableCenterXConstraint.constant -= 1000
        self.specialWeaponCollectionView.reloadData()

        UIView.animate(withDuration: 0.50, animations: {
            
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    @IBAction func changedWeapon(_ sender: UIButton) {
        
        
        self.specialWeaponCollectionViewCenterXConstraint.constant += 1000
        self.specialWeaponDetailVewCenterXConstraint.constant += 1000
        
        UIView.animate(withDuration: 0.60, animations: {
            
            self.view.layoutIfNeeded()
            
        })
    
    

    }
 
    @IBAction func changedUpgradeItem(_ sender: UIButton) {
        
        self.upgradeObjectCollectionViewCenterXConstraint.constant += 1000
        self.upgradeObjectDetailViewCenterXConstraint.constant += 1000
        
        UIView.animate(withDuration: 0.60, animations: {
            
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    
    var selectedUpgradeItemType: CollectibleType?
    var selectedSpecialWeaponType: CollectibleType?
    var selectedPlayerType: PlayerType?
    
    @IBAction func saveProfile(_ sender: UIButton) {
        savePlayerProfile()
    }
    
    
    var existingPlayerProfile: PlayerProfile?
    var dateCreatedOrLastModified: Date = Date()
    
    /** CoreData Stack **/

    var managedObjectContext:NSManagedObjectContext{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: failed to access the shared application delegate while creating a player profile")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var entityDescription: NSEntityDescription{
        
        return NSEntityDescription.entity(forEntityName: "PlayerProfile", in: self.managedObjectContext)!
        
    }
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDelegateAndDataSourcePropertiesForUIElements()
        
        if(!willCreateNewProfile && self.selectedPlayerProfile != nil){
            
            /** Detail Views are positioned on screen; namefiled, avatar, special weapon view, and upgrade object view are configured so as to be consistent with selected player profile which the user may modify **/
            resetNameFieldTextBasedOnPlayerProfile()
            resetAvatarBasedOnPlayerProfile()
            resetUpgradeObjectDetailViewBasedOnPlayerProfile()
            resetSpecialWeaponDetailViewBasedOnPlayerProfile()
            positionSpecialWeaponDetailViewOnScreen()
            positionUpgradeObjectDetailViewOnScreen()
            
     
            
            
            
        } else {
            
            positionDetailViewsOffScreen()
        }
        
        positionCollectionViewsOffScreen()
        
        self.view.layoutIfNeeded()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }

    
    func savePlayerProfile(){
        
        
        if nameTextField.text == nil || (nameTextField.text != nil && nameTextField.text!.isEmpty){
            showMessage(title: "Error: No Name Entered", message: "Please enter a valid name in order to save the player profile")
            return
            
        }
        
        if selectedUpgradeItemType == nil{
            showMessage(title: "Error: No Special Item Selected", message: "Please select a special upgrade item in order to save the player profile")
            return
        }
        
        if selectedSpecialWeaponType == nil{
            showMessage(title: "Error: No Special Weapon Selected", message: "Please select a special weapon in order to save the player profile")
            return
        }
        
        if selectedPlayerType == nil{
            showMessage(title: "Error: No Player Type Selected", message: "Please select a player type in order to save the player profile")
            return
        }
        
        if selectedPlayerProfile == nil{
            
              let playerProfile = PlayerProfile(entity: self.entityDescription, insertInto: self.managedObjectContext)
            
            playerProfile.dateCreated = self.dateCreatedOrLastModified as NSDate
            playerProfile.name = self.nameTextField.text!
            playerProfile.playerType = Int64(self.selectedPlayerType!.getIntegerValue())
            playerProfile.specialWeapon = Int64(self.selectedSpecialWeaponType!.rawValue)
            playerProfile.upgradeCollectible = Int64(self.selectedUpgradeItemType!.rawValue)
            self.selectedPlayerProfile = playerProfile
            
        } else {
        
            selectedPlayerProfile!.name = self.nameTextField.text!
            selectedPlayerProfile!.playerType = Int64(self.selectedPlayerType!.getIntegerValue())
            selectedPlayerProfile!.specialWeapon =  Int64(self.selectedSpecialWeaponType!.rawValue)
            selectedPlayerProfile!.upgradeCollectible = Int64(self.selectedUpgradeItemType!.rawValue)
        }
      
        
        do {
            try managedObjectContext.save()
            
            showMessage(title: "New Player Saved!", message: "You are ready to go take on some killer zombies!")
            
        } catch let error as NSError {
            //Error handling: validation errors
        }
    
    }
    
    
    
    func showMessage(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(okay)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension PlayerProfileViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedPlayerType = PlayerType.allPlayerTypes[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.bounds.height*0.50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let origin = CGPoint(x: 0.0, y: 0.0)
        let size = CGSize(width: pickerView.bounds.size.width, height: pickerView.bounds.size.height*0.50)
        let imageViewFrame = CGRect(origin: origin, size: size)
        
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.contentMode = .scaleAspectFit
        let texture = PlayerType.allPlayerTypes[row].getTexture(textureType: .gun)
        let image = UIImage(cgImage: texture.cgImage())
        imageView.image = image
        
        return imageView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PlayerType.allPlayerTypes.count
    }
}

extension PlayerProfileViewController{
    
    
    
}


extension PlayerProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView.tag == PlayerProfileCollectionViewTag.SpecialWeaponCV.rawValue{
            
            
            self.selectedSpecialWeaponType = CollectibleType.SpecialWeaponTypes[indexPath.row]
            
            if let specialWeapon = self.selectedSpecialWeaponType{
                
                specialWeaponImageView.contentMode = .scaleAspectFit
                self.specialWeaponImageView.image = UIImage(cgImage: specialWeapon.getTexture().cgImage())
                self.specialWeaponLabel.text = specialWeapon.getCollectibleName()
            }
            
            
            self.specialWeaponCollectionViewCenterXConstraint.constant -= 1000
            self.specialWeaponDetailVewCenterXConstraint.constant -= 1000
            
            UIView.animate(withDuration: 0.60, animations: {
                
                self.view.layoutIfNeeded()
                
            })
        }
        
        if collectionView.tag == PlayerProfileCollectionViewTag.UpgradeObjectCV.rawValue{
            
            self.selectedUpgradeItemType = CollectibleType.UpgradeItemTypes[indexPath.row]

        
            if let upgradeObject = self.selectedUpgradeItemType{
                
                self.upgradeObjectImageView.contentMode = .scaleAspectFit
                self.upgradeObjectImageView.image = UIImage(cgImage: upgradeObject.getTexture().cgImage())
                self.upgradeObjectLabel.text = upgradeObject.getCollectibleName()
            }
            
          
            

            
            self.upgradeObjectCollectionViewCenterXConstraint.constant -= 1000
            self.upgradeObjectDetailViewCenterXConstraint.constant -= 1000
            
            UIView.animate(withDuration: 0.60, animations: {
                
                self.view.layoutIfNeeded()
                
            })
            
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == PlayerProfileCollectionViewTag.SpecialWeaponCV.rawValue{
            
            return CollectibleType.SpecialWeaponTypes.count
        }
        
        if collectionView.tag == PlayerProfileCollectionViewTag.UpgradeObjectCV.rawValue{
            
            return CollectibleType.UpgradeItemTypes.count
            
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == PlayerProfileCollectionViewTag.SpecialWeaponCV.rawValue{
            
            let specialWeaponCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialWeaponCell", for: indexPath) as! SpecialWeaponCell
            
            let texture = CollectibleType.SpecialWeaponTypes[indexPath.row].getTexture()
            
            let image = UIImage(cgImage: texture.cgImage())
            
            specialWeaponCell.imageView.image = image
            
            return specialWeaponCell
        }
        
        if collectionView.tag == PlayerProfileCollectionViewTag.UpgradeObjectCV.rawValue{
            
            let upgradeObjectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpgradeObjectCell", for: indexPath) as! UpgradeObjectCell
            
            let texture = CollectibleType.UpgradeItemTypes[indexPath.row].getTexture()
            
            let image = UIImage(cgImage: texture.cgImage())
            
            upgradeObjectCell.imageView.image = image
            
            return upgradeObjectCell

            
        }
        
        return UICollectionViewCell()
    }
    
}

extension PlayerProfileViewController: UITextFieldDelegate{
    

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
    }
}



extension PlayerProfileViewController: GADBannerViewDelegate{
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
   
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    
}

/**
 
 if(!willCreateNewProfile  && self.selectedPlayerProfile != nil){
 
 
 
 self.specialWeaponDetailVewCenterXConstraint.constant = 0
 self.upgradeObjectDetailViewCenterXConstraint.constant = 0
 
 self.chooseWeaponLableCenterXConstraint.constant = -1000
 self.chooseUpgradeObjectLabelCenterXConstraint.constant = -1000
 
 
 
 
 
 } else {
 
 
 self.specialWeaponDetailVewCenterXConstraint.constant = 1000
 self.upgradeObjectDetailViewCenterXConstraint.constant = 1000
 
 
 }
 
 self.specialWeaponCollectionViewCenterXConstraint.constant = -1000
 self.upgradeObjectCollectionViewCenterXConstraint.constant = -1000
 
 
 self.view.layoutIfNeeded()
 
 **/
