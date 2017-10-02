//
//  HUD.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/15/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class HUDManager{
    
    
    static let sharedManager = HUDManager()
    
    private var isLoading = false
    
    /** Cached Blue Bars for Health **/
    
    var blueBar0: SKNode?
    var blueBar1: SKNode?
    var blueBar2: SKNode?
    var blueBar3: SKNode?
    var blueBar4: SKNode?
    var blueBar5: SKNode?
    var blueBar6: SKNode?
    var blueBar7: SKNode?
    var blueBar8: SKNode?
    var blueBar9: SKNode?
    var blueBar10: SKNode?
    var blueBar11: SKNode?
    var blueBar12: SKNode?
    var blueBar13: SKNode?
    var blueBar14: SKNode?
    var blueBar15: SKNode?
    
    /** Cached Red Bars for Bullets **/
    
    var redBar0: SKNode?
    var redBar1: SKNode?
    var redBar2: SKNode?
    var redBar3: SKNode?
    var redBar4: SKNode?
    var redBar5: SKNode?
    var redBar6: SKNode?
    var redBar7: SKNode?
    var redBar8: SKNode?
    var redBar9: SKNode?
    var redBar10: SKNode?
    var redBar11: SKNode?
    var redBar12: SKNode?
    var redBar13: SKNode?
    var redBar14: SKNode?
    var redBar15: SKNode?
    var redBarFull: SKNode?
    
    var mainHUDNode: SKNode!
    var healthIndicator: SKNode!
    var bulletIndicator: SKNode!
    
    private init() {
        
        if(self.isLoading){
            
            fatalError("Error: attempted to initialize a new singleton instance while instantiation of the singleton is already in progress")
            
        } else {
            
            self.isLoading = true
            
            NotificationCenter.default.post(name: Notification.Name.GetDidFinishLoadingHUDNotification(), object: nil, userInfo: [
                    "loadingLevel":0
                ])

            
            loadMainHUDNode()
            
            NotificationCenter.default.post(name: Notification.Name.GetDidFinishLoadingHUDNotification(), object: nil, userInfo: [
                "loadingLevel":1
                ])
            
            loadBlueBarIndicators()
            
            NotificationCenter.default.post(name: Notification.Name.GetDidFinishLoadingHUDNotification(), object: nil, userInfo: [
                "loadingLevel":2
                ])
            
            loadRedBarIndicators()
            
            NotificationCenter.default.post(name: Notification.Name.GetDidFinishLoadingHUDNotification(), object: nil, userInfo: [
                "loadingLevel":3
                ])
        
            updateBulletCount(withUnits: 30)
            updateHealthCount(withUnits: 15)
            
            NotificationCenter.default.post(name: Notification.Name.GetDidFinishLoadingHUDNotification(), object: nil, userInfo: [
                "loadingLevel":4
                ])
        }

        
    }
    
    
    func getHUD() -> SKNode{
        
        return self.mainHUDNode
        
    }
    
    
    func updateHealthCount(withUnits units: Int){
        
            print("Updating playe health with health units \(units)")
            let blueBarPos = self.healthIndicator.position
            self.healthIndicator.removeFromParent()
            self.healthIndicator = nil
        
            let blueBarIndicator = getBlueBar(forUnitNumber: units)
        
            self.healthIndicator = blueBarIndicator
            self.healthIndicator.move(toParent: self.mainHUDNode)
            self.healthIndicator.position = blueBarPos

        
    }
    
    func updateBulletCount(withUnits units: Int){
        
        print("Updating the bullet count....")
        
            print("Updating the bullet indicator to show \(units) bullets")
            let redBarPos = self.bulletIndicator.position
            self.bulletIndicator.removeFromParent()
            self.bulletIndicator = nil
        
            let redBarIndicator = getRedBar(forUnitNumber: units)
        
            self.bulletIndicator = redBarIndicator
            self.bulletIndicator.move(toParent: self.mainHUDNode)
            self.bulletIndicator.position = redBarPos

       
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func getRedBar(forUnitNumber units: Int) -> SKNode{
        switch units {
        case 29,30:
            return self.redBarFull!
        case 27,28:
            return self.redBar15!
        case 25,26:
            return self.redBar14!
        case 23,24:
            return self.redBar13!
        case 21,22:
            return self.redBar12!
        case 19,20:
            return self.redBar11!
        case 17,18:
            return self.redBar10!
        case 15,16:
            return self.redBar9!
        case 13,14:
            return self.redBar8!
        case 11,12:
            return self.redBar7!
        case 9,10:
            return self.redBar6!
        case 8,9:
            return self.redBar5!
        case 6,7:
            return self.redBar4!
        case 4,5:
            return self.redBar3!
        case 2,3:
            return self.redBar2!
        case 1,2:
            return self.redBar1!
        case 0:
            return self.redBar0!
        default:
            return self.redBar0!
        }
    }
    
    
    
    private func getBlueBar(forUnitNumber units: Int) -> SKNode{
        switch units {
        case 15:
            return self.blueBar15!
        case 14:
            return self.blueBar14!
        case 13:
            return self.blueBar13!
        case 12:
            return self.blueBar12!
        case 11:
            return self.blueBar11!
        case 10:
            return self.blueBar10!
        case 9:
            return self.blueBar9!
        case 8:
            return self.blueBar8!
        case 7:
            return self.blueBar7!
        case 6:
            return self.blueBar6!
        case 5:
            return self.blueBar5!
        case 4:
            return self.blueBar4!
        case 3:
            return self.blueBar3!
        case 2:
            return self.blueBar2!
        case 1:
            return self.blueBar1!
        case 0:
            return self.blueBar0!
        default:
            return self.blueBar0!
        }
    }
    
    private func loadMainHUDNode(){
        
        guard let hudNode = SKScene(fileNamed: "user_interface")?.childNode(withName: "hudNode") else { fatalError("Error: HUD node failed to load")}
        
        self.mainHUDNode = hudNode
        
        
        guard let bulletIndicator = hudNode.childNode(withName: "bulletIndicator") else {
            fatalError("Error: bulletIndicator failed to load")
        }
        
        self.bulletIndicator = bulletIndicator
        
        guard let healthIndicator = hudNode.childNode(withName: "healthIndicator") else {
            fatalError("Error: healthIndicator failed to load")
        }
        
        self.healthIndicator = healthIndicator
        
    }
    
    
    
  
 
    private func loadBlueBarIndicators(){
        
        if haveLoadedBlueBars() { return }
        
        guard let blueBar0 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BarIndicator") else { fatalError("Error: failed to load a blueBar0 texture") }
        
        self.blueBar0 = blueBar0
        
        guard let blueBar1 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator1") else { fatalError("Error: failed to load a blueBar1 texture") }
        
        self.blueBar1 = blueBar1
        
        guard let blueBar2 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator2") else { fatalError("Error: failed to load a blueBar2 texture") }
        
        self.blueBar2 = blueBar2
        
        guard let blueBar3 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator3") else { fatalError("Error: failed to load a blueBar3 texture") }
        
        self.blueBar3 = blueBar3
        
        guard let blueBar4 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator4") else { fatalError("Error: failed to load a blueBar4 texture") }
        
        self.blueBar4 = blueBar4
        
        guard let blueBar5 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator5") else { fatalError("Error: failed to load a redBar0 texture") }
        
        self.blueBar5 = blueBar5

      
        guard let blueBar6 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator6") else { fatalError("Error: failed to load a blueBar6 texture") }
        
        self.blueBar6 = blueBar6
        
        guard let blueBar7 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator7") else { fatalError("Error: failed to load a blueBar7 texture") }
        
        self.blueBar7 = blueBar7
        
        guard let blueBar8 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator8") else { fatalError("Error: failed to load a blueBar8 texture") }
        
        self.blueBar8 = blueBar8
        
        guard let blueBar9 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator9") else { fatalError("Error: failed to load a blueBar9 texture") }
        
        self.blueBar9 = blueBar9
        
        guard let blueBar10 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator10") else { fatalError("Error: failed to load a blueBar10 texture") }
        
        self.blueBar10 = blueBar10
        
        guard let blueBar11 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator11") else { fatalError("Error: failed to load a blueBar11 texture") }
        
        self.blueBar11 = blueBar11
        
        guard let blueBar12 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator12") else { fatalError("Error: failed to load a blueBar12 texture") }
        
        self.blueBar12 = blueBar12
        
        guard let blueBar13 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator13") else { fatalError("Error: failed to load a blueBar13 texture") }
        
        self.blueBar13 = blueBar13
        
        guard let blueBar14 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator14") else { fatalError("Error: failed to load a blueBar14 texture") }
        
        self.blueBar14 = blueBar14
        
        guard let blueBar15 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BlueBarIndicator15") else { fatalError("Error: failed to load a blueBar15 texture") }
        
        self.blueBar15 = blueBar15
        
        print("Finished loading blue bar indicators")
    }
        
    
    
    
    private func loadRedBarIndicators(){
        
        if haveLoadedRedBars() { return }
        
        guard let redBar0 = SKScene(fileNamed: "user_interface")?.childNode(withName: "BarIndicator") else { fatalError("Error: failed to load a redBar0 texture") }
        
        self.redBar0 = redBar0
        
        guard let redBar1 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator0") else { fatalError("Error: failed to load a redBar1 texture") }
        
        self.redBar1 = redBar1
        
        guard let redBar2 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator1") else { fatalError("Error: failed to load a redBar2 texture") }
        
        self.redBar2 = redBar2
        
        guard let redBar3 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator2") else { fatalError("Error: failed to load a redBar3 texture") }
        
        self.redBar3 = redBar3
        
        guard let redBar4 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator3") else { fatalError("Error: failed to load a redBar4 texture") }
        
        self.redBar4 = redBar4
        
        guard let redBar5 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator4") else { fatalError("Error: failed to load a redBar5 texture") }
        
        self.redBar5 = redBar5
        
        guard let redBar6 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator5") else { fatalError("Error: failed to load a redBar6 texture") }
        
        self.redBar6 = redBar6
        
        guard let redBar7 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator6") else { fatalError("Error: failed to load a redBar7 texture") }
        
        self.redBar7 = redBar7
        
        guard let redBar8 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator7") else { fatalError("Error: failed to load a redBar8 texture") }
        
        self.redBar8 = redBar8
        
        guard let redBar9 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator8") else { fatalError("Error: failed to load a redBar9 texture") }
        
        self.redBar9 = redBar9
        
        guard let redBar10 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator9") else { fatalError("Error: failed to load a redBar10 texture") }
        
        self.redBar10 = redBar10
        
        guard let redBar11 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator10") else { fatalError("Error: failed to load a redBar11 texture") }
        
        self.redBar11 = redBar11
        
        guard let redBar12 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator11") else { fatalError("Error: failed to load a redBar12 texture") }
        
        self.redBar12 = redBar12
        
        guard let redBar13 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator12") else { fatalError("Error: failed to load a redBar13 texture") }
        
        self.redBar13 = redBar13
        
        
        guard let redBar14 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator13") else { fatalError("Error: failed to load a redBar14 texture") }
        
        self.redBar14 = redBar14
        
        guard let redBar15 = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator14") else { fatalError("Error: failed to load a redBar15 texture") }
        
        self.redBar15 = redBar15
        
        guard let redBarFull = SKScene(fileNamed: "user_interface")?.childNode(withName: "RedBarIndicator15") else { fatalError("Error: failed to load a redBarFull texture") }
        
        self.redBarFull = redBarFull
        
        print("Finished loading red bar indicators")


    }
    
    
    private func haveLoadedBlueBars() -> Bool{
        
        return (self.blueBar0 != nil &&
            self.blueBar1 != nil &&
            self.blueBar2 != nil &&
            self.blueBar3 != nil &&
            self.blueBar4 != nil &&
            self.blueBar5 != nil &&
            self.blueBar6 != nil &&
            self.blueBar7 != nil &&
            self.blueBar8 != nil &&
            self.blueBar9 != nil &&
            self.blueBar10 != nil &&
            self.blueBar11 != nil &&
            self.blueBar12 != nil &&
            self.blueBar13 != nil &&
            self.blueBar14 != nil &&
            self.blueBar15 != nil)
    }
    
    private func haveLoadedRedBars() -> Bool{
        
        return (self.redBar0 != nil &&
            self.redBar1 != nil &&
            self.redBar2 != nil &&
            self.redBar3 != nil &&
            self.redBar4 != nil &&
            self.redBar5 != nil &&
            self.redBar6 != nil &&
            self.redBar7 != nil &&
            self.redBar8 != nil &&
            self.redBar9 != nil &&
            self.redBar10 != nil &&
            self.redBar11 != nil &&
            self.redBar12 != nil &&
            self.redBar13 != nil &&
            self.redBar14 != nil &&
            self.redBar15 != nil &&
            self.redBarFull != nil)
    }
    
}


