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
    
    @IBAction func startGame(_ sender: Any) {
        
        self.progressBar.isHidden = false
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.progressBar.isHidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progressBar.isHidden = true
        
          NotificationCenter.default.addObserver(self, selector: #selector(updateProgressBar(notification:)), name: Notification.Name(rawValue:Notification.Name.didMakeProgressTowardsGameLoadingNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func updateProgressBar(notification: Notification?){
        
        if let progressAmount = notification?.userInfo?["progressAmount"] as? Float{
            
            self.progressBar.progress += Float(progressAmount)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startMissionPlaySegue"){
            
            self.progressBar.isHidden = false

        }
    }
    
}
