//
//  SortingCriteriaTableViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 10/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class SortingCriteriaTableViewController: UITableViewController{
    
    
    var selectedCriterion: PlayerProfile.GameStatSortCriteria?
    
    var sortingCriteria: [PlayerProfile.GameStatSortCriteria]{
        
        return PlayerProfile.GameStatSortCriteria.AllSortingCriteria
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //MARK:    TableViewController DataSource and Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedCriterion = self.sortingCriteria[indexPath.row]
        
        print("The selected criterion has been reset to \(self.selectedCriterion?.getSortingClosureName())")
        
      NotificationCenter.default.post(name: Notification.Name.GetDidRequestNewSortingCriterionNotification(), object: self, userInfo: nil)
  
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        self.selectedCriterion = nil
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sortingCriteria.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortingCriteriaCell", for: indexPath)
    
        let sortingCriterion = sortingCriteria[indexPath.row]
        
        cell.textLabel?.text = sortingCriterion.getSortingClosureName()
        
        return cell
    }
    
    
}
