//
//  GameMenuViewController.swift
//  Zombies At Large
//
//  Created by Aleksander Makedonski on 9/23/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit


class GameMenuViewController: UIViewController{
    
    
    var stackView: UIStackView?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        let startButton = UIButton(type: .system)
        startButton.addTarget(self, action: #selector(loadLevel1), for: UIControlEvents.allTouchEvents)
        
        startButton.setTitle("Start Game", for: UIControlState.normal)
    
        
        self.stackView = UIStackView(arrangedSubviews: [startButton])
        self.stackView!.axis = .vertical
        self.stackView!.alignment = .center
        self.stackView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView!)
        
        NSLayoutConstraint.activate([
            
            stackView!.topAnchor.constraint(equalTo: view.topAnchor),
            stackView!.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView!.rightAnchor.constraint(equalTo: view.rightAnchor),
            stackView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            ])
        
        
    }
    
    
    @objc func loadLevel1(){
        
        let gameViewController = GameViewController()
        
        present(gameViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.cyan
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
