//
//  PlayerProfile+CoreDataClass.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/29/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PlayerProfile)
public class PlayerProfile: NSManagedObject {

    
    func getFormattedDateString() -> String{
        
        guard let date = self.dateCreated as Date? else {
            return "No Date Recorded"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}
