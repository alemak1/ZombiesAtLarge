//
//  MainMenuController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MainMenuController: UIViewController{

    
    /** Unwind segue - allows user to return from CreateProfile and LoadProfile view controller to the profile options view controller **/
    @IBAction func unwindToMainMenuController(segue: UIStoryboardSegue){
    
    }
    
    var selectedPlayerProfile: PlayerProfile?
    
    @IBOutlet weak var playerProfileOptionsWindow: UIView!
    
    
    @IBOutlet weak var gameStartOptionsCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileOptionsCenterXConstraint: NSLayoutConstraint!
    
    
    
    @IBAction func showPlayerProfileOptions(_ sender: Any) {
        
        self.gameStartOptionsCenterXConstraint.constant += 2000
        self.profileOptionsCenterXConstraint.constant += 2000
        
        
        UIView.animate(withDuration: 0.70, animations: {
            
            
            self.view.layoutIfNeeded()
        })
    }
    
    
    func showMessage(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(okay)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showGameStartOptions(_ sender: UIButton) {
        
        
        if(self.selectedPlayerProfile == nil){
            showMessage(title: "No player profile selected!", message: "Please select a player profile or create a new player profile to start the game!")
            
            return
        }
        
        self.gameStartOptionsCenterXConstraint.constant -= 2000
        self.profileOptionsCenterXConstraint.constant -= 2000
        
        UIView.animate(withDuration: 0.70, animations: {
            
            
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func startGame(_ sender: Any) {
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.playerProfileOptionsWindow.alpha = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameStartOptionsCenterXConstraint.constant = 2000
        
        self.view.layoutIfNeeded()
        
        self.playerProfileOptionsWindow.alpha = 0.0

        
        UIView.animate(withDuration: 3.00, animations: {
            

            self.view.layoutIfNeeded()
            
        })
        
          NotificationCenter.default.addObserver(self, selector: #selector(updateProgressBar(notification:)), name: Notification.Name(rawValue:Notification.Name.didMakeProgressTowardsGameLoadingNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func updateProgressBar(notification: Notification?){
        
        if let progressAmount = notification?.userInfo?["progressAmount"] as? Float{
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startMissionPlaySegue"){
            
            if let gameViewController = segue.destination as? GameViewController{
                
                gameViewController.playerProfile = self.selectedPlayerProfile
                
            } else if let navigationController = segue.destination as? GameViewNavigationController{
                
                navigationController.playerProfile = self.selectedPlayerProfile
            }

        }
        
        if(segue.identifier == "loadSavedGameSegue"){
            if let savedGamesViewController = segue.destination as? SavedGamesViewController{
                
                savedGamesViewController.playerProfile = self.selectedPlayerProfile
                
            }
        }
    }
    
}
