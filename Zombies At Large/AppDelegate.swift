//
//  AppDelegate.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import UIKit
import CoreData



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    
    var hudLoadingOperationQueue: OperationQueue!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //Asynchronously preload HUD display
        
        /**
        hudLoadingOperationQueue = OperationQueue()
        
        hudLoadingOperationQueue.addOperation {
            
            let _ = HUDManager.sharedManager

        }
        
        hudLoadingOperationQueue.qualityOfService = .background
        
        **/
    
        DispatchQueue.global().async {
            
            let _ = HUDManager.sharedManager

        }
    
        
        /**
        
        **/
        
        /**
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = GameViewController(nibName: nil, bundle: nil)
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        **/
        
     
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ZombieMaster")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func deletePlayers(){
    
        let fetchRequest = NSFetchRequest<PlayerProfile>(entityName: "PlayerProfile")
        
        var playerProfiles = [PlayerProfile]()
        
        do {
             playerProfiles = try self.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error occurred while deleting players")
        }
        
        
        if(!playerProfiles.isEmpty){
            for playerProfile in playerProfiles{
                self.persistentContainer.viewContext.delete(playerProfile)
            }
        } else {
            print("No player profiles retrieved from databased")
        }
    }
    
    func cleanBadData(){
        
        let managedContext = persistentContainer.viewContext
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "GameLevelStatReview", in: managedContext)!
        
        let fetchRequest = NSFetchRequest<GameLevelStatReview>(entityName: "GameLevelStatReview")
        
        let allStatReviews = try! managedContext.fetch(fetchRequest)
        
        for statReview in allStatReviews{
            if statReview.playerProfile == nil{
                try! managedContext.delete(statReview)
            }
        }
        
        print("Finished cleaning bad data...")
    }
    
    
    func insertSamplePlayerProfiles(){
        
        let managedContext = persistentContainer.viewContext
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "PlayerProfile", in: managedContext)!
        
        
        let count = try! managedContext.count(for: PlayerProfile.fetchRequest())
        
        if count > 0 {
            print("Sample player data has already been inserted!")
            return
            
        }
        
        let newPlayer1 = PlayerProfile(entity: entityDescription, insertInto: managedContext)
        newPlayer1.dateCreated = Date() as NSDate
        newPlayer1.name = "Player1"
        newPlayer1.playerType = Int64(PlayerType.hitman1.getIntegerValue())
        newPlayer1.specialWeapon = 1
        newPlayer1.upgradeCollectible = 1
        newPlayer1.gameSessions = nil
        
        let newPlayer2 = PlayerProfile(entity: entityDescription, insertInto: managedContext)
        newPlayer2.dateCreated = Date() as NSDate
        newPlayer2.name = "Player2"
        newPlayer2.playerType = Int64(PlayerType.survivor2.getIntegerValue())
        newPlayer2.specialWeapon = 2
        newPlayer2.upgradeCollectible = 2
        newPlayer2.gameSessions = nil
        
        let newPlayer3 = PlayerProfile(entity: entityDescription, insertInto: managedContext)
        newPlayer3.dateCreated = Date() as NSDate
        newPlayer3.name = "Player3"
        newPlayer3.playerType = Int64(PlayerType.womanOld.getIntegerValue())
        newPlayer3.specialWeapon = 3
        newPlayer3.upgradeCollectible = 3
        newPlayer3.gameSessions = nil
        
        do {
            try managedContext.save()
            print("Sample player profiles successfully saved!")
        } catch let error as NSError {
            print("Error: failed to save sample player profiles")
        }
    }

}

