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
        
        return cell
    }
    
}
