//
//  PlayerProfileTableViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PlayerProfileTableViewController: UITableViewController{
    
    var selectedPlayerProfile: PlayerProfile?{
        
        get{
            if let mainMenuViewController = self.presentingViewController as? MainMenuController{
            
                return mainMenuViewController.selectedPlayerProfile
                
            } else if let rootViewController = self.navigationController?.viewControllers.first as? PlayerProfileNavigationController{
                
                return rootViewController.selectedPlayerProfile
                
            } else if let presentingViewController = self.presentingViewController as? PlayerProfileNavigationController {
                
                return presentingViewController.selectedPlayerProfile
            } else {
                return nil
            }
        }
        
        set(newPlayerProfile){
            if let mainMenuViewController = self.presentingViewController as? MainMenuController{
                
                mainMenuViewController.selectedPlayerProfile = newPlayerProfile
            } else if let rootViewController = self.navigationController?.viewControllers.first as? PlayerProfileNavigationController{
                
                 rootViewController.selectedPlayerProfile = newPlayerProfile
                
            } else if let presentingViewController = self.presentingViewController as? PlayerProfileNavigationController {
                
                 presentingViewController.selectedPlayerProfile = newPlayerProfile
            }
        }
    }
    
    var managedObjectContext: NSManagedObjectContext{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: failed to access the applicated delegate while attemping to perform save or fetch operations for player profiles on the managed object context")
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    
    
    lazy var playerProfiles: [PlayerProfile]? = {
        
        var playerProfiles: [PlayerProfile]?
        
        let fetchRequest = NSFetchRequest<PlayerProfile>(entityName: "PlayerProfile")

        do{
            playerProfiles = try self.managedObjectContext.fetch(fetchRequest)
            
        } catch let error as NSError{
            
        }
        
        return playerProfiles
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "modifyProfileSegue"){
            if let modifyProfileVC = segue.destination as? PlayerProfileViewController{
                
                modifyProfileVC.existingPlayerProfile = self.selectedPlayerProfile
                
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if(identifier == "modifyProfileSegue"){
            
            if(self.selectedPlayerProfile == nil){
                showMessage(title: "No Player Profile Selected", message: "Please select an existing player profile in order to begin editing a profile ")
                return false
                
            } else {
                
                return true
            }
        }
        
        return true
    }
    
    func showMessage(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(okay)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let playerProfiles = playerProfiles{
            
                self.selectedPlayerProfile = playerProfiles[indexPath.row]
        
        }

    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        self.selectedPlayerProfile = nil
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        guard let playerProfiles = self.playerProfiles else {
            return 0
        }
        
        return playerProfiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerProfileCell") as! PlayerProfileTableViewCell
        
        if let playerProfiles = self.playerProfiles{
            
            let playerProfile = playerProfiles[indexPath.row]
            let playerTypeRawValue = Int(playerProfile.playerType)
            let playerType = PlayerType(withIntegerValue: playerTypeRawValue)
            let cgImage = playerType.getTexture(textureType: .gun).cgImage()
            cell.avatarImageView.image = UIImage(cgImage: cgImage)
            

            let name = playerProfile.name
            let dateCreated = playerProfile.getFormattedDateString()
            
            cell.playerNameLabel.text = "Name: \(name)"

        }
        
        
        return cell
    }
    
}
