//
//  GameViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/1/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit




class GameViewController: UIViewController {


    lazy var skView: SKView? = {
        
        let skView = SKView()
        
        skView.translatesAutoresizingMaskIntoConstraints = false
        
        return skView
    }()
    
    
    lazy var progressView: UIProgressView = {
        
        /**
        let xPos = UIScreen.main.bounds.width*0.20
        let yPos = UIScreen.main.bounds.height*0.50
        let width = UIScreen.main.bounds.width*0.60
        let height = UIScreen.main.bounds.height*0.10
        
        let pvRect = CGRect(x: xPos, y: yPos, width: width, height: height)
         **/
        let progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.isHidden = true
       // progressView.trackImage = #imageLiteral(resourceName: "barBack_horizontalMid")
       // progressView.progressImage = #imageLiteral(resourceName: "barRed_horizontalMid")
        
        return progressView
        
    }()
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let skView = self.skView{
     
            self.view.addSubview(skView)
            self.view.addSubview(progressView)

        NSLayoutConstraint.activate([
            
            /**
            skView.widthAnchor.constraint(equalToConstant: 700),
            skView.heightAnchor.constraint(equalToConstant: 700),
            skView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            skView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
             **/
            
            /**
            progressView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            progressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 50),
            progressView.widthAnchor.constraint(equalToConstant: 250),
             **/
            
            /**
            progressView.topAnchor.constraint(equalTo: self.view.topAnchor),
            progressView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            progressView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.10),
            **/
            
            skView.topAnchor.constraint(equalTo: self.view.topAnchor),
            skView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            skView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            skView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            
            ])
        
           
            
        } else {
            fatalError("Error: failed to add the skView")
            
        }
        

    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.cyan
        
        
        if let skView = self.skView {
            
            progressView.isHidden = false
            
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(currentGameLevel: .Level1, progressView: self.progressView)
            
           
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
                
            // Present the scene
            skView.presentScene(scene)
            
    
            
            
        }
    }
    
  
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
