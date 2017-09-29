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

enum PlayerProfileCollectionViewTag: Int{
        case SpecialWeaponCV = 1
        case UpgradeObjectCV = 2
}

class PlayerProfileViewController: UIViewController{
    
    /** IB Outlets and Actions **/
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var avatarPicker: UIPickerView!
    @IBOutlet weak var specialWeaponCollectionView: UICollectionView!
    @IBOutlet weak var upgradeObjectCollectionView: UICollectionView!
    
    

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
        
        self.nameTextField.delegate = self
        
        self.avatarPicker.delegate = self
        self.avatarPicker.dataSource = self
        
        self.specialWeaponCollectionView.dataSource = self
        self.specialWeaponCollectionView.delegate = self
        
        self.upgradeObjectCollectionView.dataSource = self
        self.upgradeObjectCollectionView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func savePlayerProfile(){
        
        if existingPlayerProfile == nil{
            
              let playerProfile = PlayerProfile(entity: self.entityDescription, insertInto: self.managedObjectContext)
            
            playerProfile.dateCreated = self.dateCreatedOrLastModified as NSDate
            playerProfile.name = self.nameTextField.text!
            
        } else {
        
            existingPlayerProfile!.dateCreated = self.dateCreatedOrLastModified as NSDate
            existingPlayerProfile!.name = self.nameTextField.text!
        }
      
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            //Error handling: validation errors
        }
    
    }
    
}

extension PlayerProfileViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let imageView = UIImageView()
        
        return imageView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
}


extension PlayerProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == PlayerProfileCollectionViewTag.SpecialWeaponCV.rawValue{
            
            return 1
        }
        
        if collectionView.tag == PlayerProfileCollectionViewTag.UpgradeObjectCV.rawValue{
            
            return 1
            
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == PlayerProfileCollectionViewTag.SpecialWeaponCV.rawValue{
            
            let specialWeaponCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialWeaponCell", for: indexPath) as! SpecialWeaponCell
            
            return specialWeaponCell
        }
        
        if collectionView.tag == PlayerProfileCollectionViewTag.UpgradeObjectCV.rawValue{
            
            let upgradeObjectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpgradeObjectCell", for: indexPath) as! UpgradeObjectCell
            
            return upgradeObjectCell

            
        }
        
        return UICollectionViewCell()
    }
    
}

extension PlayerProfileViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
