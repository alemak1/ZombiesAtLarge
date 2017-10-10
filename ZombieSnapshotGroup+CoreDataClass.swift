//
//  ZombieSnapshotGroup+CoreDataClass.swift
//  
//
//  Created by Aleksander Makedonski on 10/10/17.
//
//

import Foundation
import CoreData

@objc(ZombieSnapshotGroup)
public class ZombieSnapshotGroup: NSManagedObject {

    func getSnapShotGroupDebugString() -> String{
        
            print("Getting zombie snapshots...")
        
            let zSnapshots = zombieSnapshots!.allObjects as! [ZombieSnapshot]
        
            print("zSnapshots \(zSnapshots.debugDescription)")
        
            let debugDescription = zSnapshots.map({$0.getZombieInformation()}).reduce("", { "\($0) \n \($1)" })
            
            return debugDescription
        }
}

