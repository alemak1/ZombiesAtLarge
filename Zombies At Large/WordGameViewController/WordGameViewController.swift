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
    
    /** A second-level of recursive nil checking occurs here; if the preloaded nodes are still nil, then the resources for the passed in the word game level are loaded again, which would result in a notification being sent a second time upon the compltion of resource loading **/
    
    @objc func loadGame(notification: Notification?){
        
        print("Getting preloaded nodes from resource loader....")

        let preloadedNodes = resourceLoader.getPreloadedNodes()
        
        if let preloadedBgNode = preloadedNodes.0, let preloadedWorldNode = preloadedNodes.1, let preloadedOverlayNoe = preloadedNodes.2{
            
            print("Preloaded nodes available.  Instantiating WordGameScene instance....")
            
            let wordGameScene = self.currentGameScene ?? WordGameScene(preloadedBackgroundNode: preloadedBgNode, preloadedWorldNode: preloadedWorldNode, preloadedOverlayNode: preloadedOverlayNoe)
            
             self.currentGameScene = wordGameScene
            
            self.progressBarLabel.text = "Let's Roll!"
            
            self.progressBarView.isHidden = true

            let nextLevel = currentGameLevel.getNextLevel()

            DispatchQueue.global().async {
                
                print("Loading resources for the next level...")
                self.resourceLoader.prepareLoadingResources(forNextLevel: nextLevel)
                
            }
            
             self.skView.presentScene(wordGameScene)
            
        } else if let rawValue = notification?.userInfo?["level"] as? Int{
            
            print("Preloaded nodes are not available...proceeding to load nodes...")
            
            let wordGameLevel = WordGameLevel(rawValue: rawValue)!
            
            resourceLoader.loadResourcesForWordGameLevel(wordGameLevel: wordGameLevel)
        }
        
    }
    
    
    func reloadCurrentGame(){
        
        guard let currentGameScene = self.currentGameScene else {
            fatalError("Error: found nil while unwrapping the current game scene")
        }
        
        self.skView.presentScene(currentGameScene)
    }
    
    /**
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
 
     **/
    
    @objc func updateProgressBar(notification: Notification?){
        
        print("Updating progress bar...")
        
        if let progress = notification?.userInfo?["progress"] as? Float{
            print("Setting progress to \(progress)")
            
            DispatchQueue.main.async {
                self.progressBar.progress = progress

            }
            
        }
    }
    
    
    
    @IBAction func loadGame(_ sender: UIButton) {
        
        print("Loading resources for Level1...")
        currentGameLevel = .Level1
        resourceLoader.loadResourcesForWordGameLevel(wordGameLevel: .Level1)
        self.progressBarView.isHidden = false
  
    
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Total progress units is: \(resourceLoader.totalProgressUnits)")
        
        //self.progressBarView.isHidden = true
        self.progressBar.progress = 0.00
        
        self.optionsMenuCenterXConstraint.constant = -2000
        self.optionsMenuIsOpen = false
        self.optionsMenu.dataSource = self
        self.optionsMenu.delegate = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadGame(notification:)), name: Notification.Name.GetDidFinishedLoadingSceneNotification(), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgressBar(notification:)), name: Notification.Name.GetDidUpdateGameLoadingProgressNotification(), object: nil)
        
    }
    
    
    
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
       
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
