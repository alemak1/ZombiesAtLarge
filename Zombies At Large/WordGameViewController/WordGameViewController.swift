//
//  WordGameViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/30/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CoreData


class WordGameViewController: UIViewController{
    
    /** Current GameScene **/
    
    var currentGameScene: WordGameScene?
    
    var player: Player?{
        
        guard let currentGameScene = self.currentGameScene else {
            return nil
        }
        
        return currentGameScene.player
    }
    
    var playerHealth: Float{
    
        guard let player = self.player else {
            return 0.00
        }
        
        return Float(player.getCurrentHealth())/30.00
        
    }
    
    var playerBullets: Float{
    
        guard let player = self.player else {
            return 0.00
        }
        
        return Float(player.getCurrentNumberOfBullets())/15.00
    
    }
    
    /** Progress View **/
    
    @IBOutlet weak var progressBarView: UIView!
    
    @IBOutlet weak var progressBarLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    /** SpriteKit View: IBOutlets for Constraints **/
    
    @IBOutlet weak var skView: SKView!
    
    @IBOutlet weak var spriteKitLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spriteKitTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spriteKitTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spriteKitBottomConstraint: NSLayoutConstraint!
    
    
    /** Options (Picker) View: IBOutlets for Constraints **/

    
    @IBOutlet weak var optionsMenuCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var optionsMenuCenterYConstraint: NSLayoutConstraint!
    
    
    /** IBOutlets and IBActions **/
    
    
    @IBOutlet weak var optionsMenu: UIPickerView!
    
    var optionsMenuIsOpen: Bool = false
    
    @IBOutlet weak var optionsButton: UIButton!
    
    @IBAction func showOptionsMenu(_ sender: UIButton) {
        
        self.optionsMenuCenterXConstraint.constant = optionsMenuIsOpen ? -2000: 0
        
        UIView.animate(withDuration: 0.50, animations: {
            
            
            self.view.layoutIfNeeded()
            
            self.optionsMenuIsOpen = !self.optionsMenuIsOpen
            
        })
    }
    
    
    /** Reference to Resource Loader **/
    
    let resourceLoader = ResourceLoader.sharedLoader
    
    var currentGameLevel: WordGameLevel!
    
    @objc func loadGame(notification: Notification?){
        
        let preloadedNodes = resourceLoader.getPreloadedNodes()
        
        let wordGameScene = self.currentGameScene ?? WordGameScene(preloadedBackgroundNode: preloadedNodes.0, preloadedWorldNode: preloadedNodes.1, preloadedOverlayNode: preloadedNodes.2)
        
        self.progressBarView.isHidden = true

        self.skView.presentScene(wordGameScene)
        
        
    }
    
    
    func reloadCurrentGame(){
        
        guard let currentGameScene = self.currentGameScene else {
            fatalError("Error: found nil while unwrapping the current game scene")
        }
        
        self.skView.presentScene(currentGameScene)
    }
    
    func startLoadingFirstLevel(){
        
        currentGameLevel = .Level1
        
        startLoadingLevel(wordGameLevel: .Level1)
    }
    
    func startLoadingLevel(wordGameLevel: WordGameLevel){
        currentGameLevel = wordGameLevel
        let nextLevel = currentGameLevel.getNextLevel()

        resourceLoader.loadBackground(forWordGameLevel: wordGameLevel, completion: {
            
            hasFinishedPreloading in
            
            if(hasFinishedPreloading){
             
                self.progressBarLabel.text = "Let's Roll!"
                self.loadGame(notification: nil)
                
                
                DispatchQueue.global().async {
                    
                    self.resourceLoader.prepareLoadingResources(forNextLevel: nextLevel)

                }
            } else {
                
                self.startLoadingLevel(wordGameLevel: self.currentGameLevel)
                
            }
            
        })
    }
    
    @objc func updateProgressBar(notification: Notification?){
        
        if let progress = notification?.userInfo?["progress"] as? Float{
            self.progressBar.progress = progress
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        self.progressBarView.isHidden = true

        self.optionsMenuCenterXConstraint.constant = -2000
        self.optionsMenuIsOpen = false
        self.optionsMenu.dataSource = self
        self.optionsMenu.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadGame(notification:)), name: Notification.Name.GetDidFinishedLoadingSceneNotification(), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(updateProgressBar(notification:)), name: Notification.Name.GetDidUpdateGameLoadingProgressNotification(), object: nil)
        
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension WordGameViewController: UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 10
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        return UIButton()
    }
    
    
}
